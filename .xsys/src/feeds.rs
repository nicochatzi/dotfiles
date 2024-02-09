use chrono::Utc;
use notify_rust::{Notification, NotificationHandle};
use rss::Channel;
use serde::{Deserialize, Serialize};
use std::collections::{HashMap, HashSet};

const CONFIG_PATH: &str = concat!(env!("CARGO_MANIFEST_DIR"), "/res/feeds.config.json");
const VISITED_PATH: &str = concat!(env!("CARGO_MANIFEST_DIR"), "/out/feeds.seen.json");
const OUTPUT_DIR: &str = concat!(env!("CARGO_MANIFEST_DIR"), "/out");
const LOGFILE: &str = concat!(env!("CARGO_MANIFEST_DIR"), "/out/feeds.log");

#[derive(Debug, clap::Args)]
pub struct FeedsCmd {
    #[clap(subcommand)]
    command: Cmd,
}

#[derive(Debug, clap::Subcommand)]
enum Cmd {
    Check(CheckOptions),
    Fetch,
}

#[derive(Debug, clap::Args)]
struct CheckOptions {
    /// Show all feed items, not just unseen
    #[clap(long, short)]
    all: bool,

    /// Mark all items as seen
    #[clap(long, short)]
    mark_as_seen: bool,

    /// Trigger notification
    #[clap(long, short)]
    notify: bool,
}

#[derive(Debug, Default, Serialize, Deserialize)]
struct FeedItem {
    name: String,
    link: String,
}

#[derive(Debug, Deserialize)]
struct FeedConfig {
    feeds: Vec<FeedItem>,
}

impl FeedConfig {
    fn load() -> anyhow::Result<Self> {
        std::fs::create_dir_all(OUTPUT_DIR)?;
        let file = std::fs::read_to_string(CONFIG_PATH)?;
        Ok(serde_json::from_str(&file)?)
    }
}

#[derive(Debug, Default, Serialize, Deserialize)]
struct FeedItemsSeen(HashSet<String>);

impl FeedItemsSeen {
    fn insert(&mut self, link: String) {
        self.0.insert(link);
    }

    fn contains(&self, link: &str) -> bool {
        self.0.contains(link)
    }
}

#[derive(Debug, Default, Serialize, Deserialize)]
struct FeedsSeen {
    last_fetch: String,
    seen_entries: HashMap<String, FeedItemsSeen>,
}

impl FeedsSeen {
    fn load() -> anyhow::Result<Self> {
        match Self::try_load() {
            Ok(seen) => Ok(seen),
            Err(_) => {
                let mut seen = Self::default();
                seen.save()?;
                Ok(seen)
            }
        }
    }

    fn try_load() -> anyhow::Result<Self> {
        let file = std::fs::read_to_string(VISITED_PATH)?;
        Ok(serde_json::from_str(&file)?)
    }

    fn save(&mut self) -> anyhow::Result<()> {
        self.last_fetch = Utc::now().to_rfc3339();
        let file = serde_json::to_string_pretty(self)?;
        std::fs::write(VISITED_PATH, file)?;
        Ok(())
    }

    fn get_mut(&mut self, feed_url: &str) -> &mut FeedItemsSeen {
        if !self.seen_entries.contains_key(feed_url) {
            self.seen_entries
                .insert(feed_url.to_owned(), FeedItemsSeen::default());
        }
        self.seen_entries.get_mut(feed_url).unwrap()
    }

    fn timestamp(&self) -> i64 {
        match chrono::DateTime::parse_from_rfc3339(&self.last_fetch) {
            Ok(dt) => dt.timestamp(),
            Err(e) => {
                log::warn!("failed to parse last fetch timestamp: {e}");
                0
            }
        }
    }
}

pub fn run(cmd: FeedsCmd) -> anyhow::Result<()> {
    match cmd.command {
        Cmd::Check(opts) => check(opts),
        Cmd::Fetch => fetch(),
    }
}

fn prepare_logger() -> fern::Dispatch {
    fern::Dispatch::new()
        .format(|out, message, record| {
            out.finish(format_args!(
                "{}[{}][{}] {}",
                chrono::Local::now().format("[%Y-%m-%d][%H:%M:%S]"),
                record.target(),
                record.level(),
                message
            ))
        })
        .level_for("reqwest", log::LevelFilter::Warn)
        .level_for("async_io", log::LevelFilter::Warn)
        .level_for("polling", log::LevelFilter::Warn)
}

fn check(opts: CheckOptions) -> anyhow::Result<()> {
    prepare_logger()
        .chain(std::io::stdout())
        .level(log::LevelFilter::Trace)
        .apply()?;

    let config = FeedConfig::load()?;
    let mut seen = FeedsSeen::load()?;
    let mut num_fetched = 0;

    visit_feeds(&config.feeds, 0, |feed_url: &str, item: &FeedItem| {
        let feed = seen.get_mut(feed_url);

        if !opts.all || !feed.contains(&item.link) {
            log::info!("From: {feed_url} -> {} @ {}", item.name, item.link);

            if opts.notify {
                trigger_notification(item).unwrap();
            }
        }

        if opts.mark_as_seen {
            feed.insert(item.link.to_owned());
        }

        num_fetched += 1;
    });

    if opts.mark_as_seen {
        seen.save().unwrap();
    }

    println!("fetched {num_fetched} items");
    Ok(())
}

fn fetch() -> anyhow::Result<()> {
    prepare_logger()
        .chain(fern::log_file(LOGFILE)?)
        .level(log::LevelFilter::Info)
        .apply()?;

    let config = match FeedConfig::load() {
        Ok(config) => config,
        Err(e) => {
            log::error!("{e}");
            return Err(e);
        }
    };

    let mut seen = match FeedsSeen::load() {
        Ok(seen) => seen,
        Err(e) => {
            log::error!("{e}");
            return Err(e);
        }
    };

    let last_fetch = seen.timestamp();

    let on_found = |feed_url: &str, item: &FeedItem| {
        let feed = seen.get_mut(feed_url);
        if !feed.contains(&item.link) {
            if let Err(e) = trigger_notification(item) {
                log::error!("while triggering notification for {}: {e}", &item.link);
            }
            feed.insert(item.link.to_owned());
        }
    };

    visit_feeds(&config.feeds, last_fetch, on_found);

    match seen.save() {
        Ok(_) => log::info!("saved seen feeds"),
        Err(e) => log::error!("{e}"),
    }

    Ok(())
}

fn visit_feeds(
    feeds: &[FeedItem],
    since_timestamp: i64,
    mut on_found: impl FnMut(&str, &FeedItem),
) {
    for feed in feeds {
        visit_feed(feed, since_timestamp, &mut on_found);
    }
}

fn visit_feed(feed: &FeedItem, since_timestamp: i64, on_found: impl FnMut(&str, &FeedItem)) {
    let channel = match read_rss_channel(&feed.link) {
        Ok(channel) => channel,
        Err(e) => {
            let link = &feed.link;
            log::error!("while fetching {link}: {e}");
            return;
        }
    };

    if does_channel_have_new_items(&channel, since_timestamp) {
        visit_channel_items(&channel, on_found);
    }
}

fn does_channel_have_new_items(channel: &Channel, since_timestamp: i64) -> bool {
    channel.items().iter().any(|item| {
        item.pub_date()
            .map(rfc822_to_unix_timestamp)
            .is_some_and(|pub_date| pub_date > since_timestamp)
    })
}

fn rfc822_to_unix_timestamp(rfc822_date: &str) -> i64 {
    match chrono::DateTime::parse_from_rfc2822(rfc822_date) {
        Ok(date) => date.timestamp(),
        Err(e) => {
            log::warn!("failed to parse RSS feed build date : {e}");
            0
        }
    }
}

fn visit_channel_items(channel: &Channel, mut on_found: impl FnMut(&str, &FeedItem)) {
    for item in channel.items() {
        let title = item.title().unwrap_or("No title");
        let link = item.link().unwrap_or("No link");
        on_found(
            &channel.link,
            &FeedItem {
                name: title.to_string(),
                link: link.to_string(),
            },
        );
    }
}

fn read_rss_channel(link: &str) -> anyhow::Result<Channel> {
    let content = reqwest::blocking::get(link)?.text()?;
    Ok(Channel::read_from(content.as_bytes())?)
}

fn trigger_notification(item: &FeedItem) -> anyhow::Result<NotificationHandle> {
    Ok(Notification::new()
        .summary(&item.name)
        .body(&item.link)
        .icon("notification-message-im")
        .hint(notify_rust::Hint::Category("email.arrived".into()))
        .show()?)
}
