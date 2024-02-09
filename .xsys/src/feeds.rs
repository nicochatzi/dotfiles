use notify_rust::{Notification, NotificationHandle};
use rss::Channel;
use serde::{Deserialize, Serialize};
use std::collections::{HashMap, HashSet};
use std::thread;
use std::time::{Duration, UNIX_EPOCH};

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
    Launch,
}

#[derive(Debug, clap::Args)]
struct CheckOptions {
    /// Only show unseen items
    #[clap(long, short)]
    only_unseen: bool,

    /// Mark all items as seen
    #[clap(long, short)]
    mark_as_seen: bool,
}

#[derive(Debug, Default, Serialize, Deserialize)]
struct FeedItem {
    name: String,
    link: String,
}

#[derive(Debug, Deserialize)]
struct FeedConfig {
    pause_seconds: u64,
    feeds: Vec<FeedItem>,
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
    last_fetch: u64,
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
        self.last_fetch = UNIX_EPOCH.elapsed()?.as_secs();
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
}

pub fn run(cmd: FeedsCmd) -> anyhow::Result<()> {
    match cmd.command {
        Cmd::Check(opts) => check(opts),
        Cmd::Launch => launch(),
    }
}

fn prepare_logging() -> fern::Dispatch {
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
}

fn check(opts: CheckOptions) -> anyhow::Result<()> {
    prepare_logging().chain(std::io::stdout()).apply()?;

    let config = setup()?;
    let mut seen = FeedsSeen::load()?;
    let mut num_fetched = 0;

    let on_found = |feed_url: &str, item: &FeedItem| {
        num_fetched += 1;
        let feed = seen.get_mut(feed_url);
        if !opts.only_unseen || !feed.contains(&item.link) {
            println!("{item:?}");
        }
        if opts.mark_as_seen {
            feed.insert(item.link.to_owned());
        }
    };

    visit_feeds(&config.feeds, on_found)?;

    if opts.mark_as_seen {
        seen.save().unwrap();
    }

    println!("fetched {num_fetched} items");
    Ok(())
}

fn launch() -> anyhow::Result<()> {
    prepare_logging().chain(fern::log_file(LOGFILE)?).apply()?;

    let config = match setup() {
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

    loop {
        let on_found = |feed_url: &str, item: &FeedItem| {
            let feed = seen.get_mut(feed_url);
            if !feed.contains(&item.link) {
                if let Err(e) = trigger_notification(item) {
                    log::error!("while triggering notification for {}: {e}", &item.link);
                }
                feed.insert(item.link.to_owned());
            }
        };

        if let Err(e) = visit_feeds(&config.feeds, on_found) {
            log::error!("{e}");
        }

        if let Err(e) = seen.save() {
            log::error!("{e}");
        }

        thread::sleep(Duration::from_secs(config.pause_seconds));
    }
}

fn setup() -> anyhow::Result<FeedConfig> {
    std::fs::create_dir_all(OUTPUT_DIR)?;
    let file = std::fs::read_to_string(CONFIG_PATH)?;
    Ok(serde_json::from_str(&file)?)
}

fn visit_feeds(
    feeds: &[FeedItem],
    mut on_found: impl FnMut(&str, &FeedItem),
) -> anyhow::Result<()> {
    for feed in feeds {
        let channel = match read_rss_channel(&feed.link) {
            Ok(channel) => channel,
            Err(e) => {
                let link = &feed.link;
                log::error!("while fetching {link}: {e}");
                continue;
            }
        };

        for item in channel.items() {
            let title = item.title().unwrap_or("No title");
            let link = item.link().unwrap_or("No link");
            on_found(
                &feed.link,
                &FeedItem {
                    name: title.to_string(),
                    link: link.to_string(),
                },
            );
        }
    }

    Ok(())
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
