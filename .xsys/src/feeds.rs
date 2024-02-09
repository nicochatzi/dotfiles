use notify_rust::Notification;
use rss::Channel;
use serde::Deserialize;
use std::collections::HashSet;
use std::thread;
use std::time::Duration;

#[derive(Deserialize)]
pub struct FeedSourceItem {
    name: String,
    link: String,
}

#[derive(Deserialize)]
pub struct FeedSources {
    feeds: Vec<FeedSourceItem>,
}

pub fn run() -> anyhow::Result<()> {
    let mut seen_entries = HashSet::new();
    let feeds: FeedSources = serde_json::from_str(&std::fs::read_to_string("feeds.json")?)?;

    loop {
        for feed in &feeds.feeds {
            let content = reqwest::blocking::get(&feed.link)?.text()?;
            let channel = Channel::read_from(content.as_bytes())?;

            for item in channel.items() {
                let title = item.title().unwrap_or("No title");
                let link = item.link().unwrap_or("No link");

                if seen_entries.insert(format!("{}{}", title, link)) {
                    Notification::new()
                        .summary(title)
                        .body(link)
                        .icon("notification-message-im")
                        .hint(notify_rust::Hint::Category("email.arrived".into()))
                        .show()?;
                }
            }
        }

        thread::sleep(Duration::from_secs(600));
    }
}
