import json
import sys
from datetime import datetime, timezone
import os
import requests
import feedparser
from plyer import notification


def load_json(file_path, default=None):
    if os.path.exists(file_path):
        with open(file_path, "r", encoding="utf-8") as f:
            return json.load(f)
    return default if default is not None else {}


def save_json(file_path, data):
    with open(file_path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2)


def fetch_feed(url):
    headers = {"User-Agent": "Mozilla/5.0"}
    response = requests.get(url, headers=headers, timeout=10)
    return feedparser.parse(response.content)


def get_entry_date(entry):
    if "published_parsed" in entry and entry["published_parsed"]:
        return datetime(*entry["published_parsed"][:6], tzinfo=timezone.utc)
    return datetime.now(timezone.utc)


def should_notify(entry, seen_entries, last_fetch):
    date = get_entry_date(entry)
    is_new = date > last_fetch
    is_unseen = entry.link not in (seen_entry["link"] for seen_entry in seen_entries)
    return is_new and is_unseen


def fetch_and_notify(state_dir):
    now = datetime.now(timezone.utc).isoformat()
    visited = os.path.join(state_dir, "seen.json")
    config = load_json("feeds.json", {"feeds": []})
    seen = load_json(visited, {"last_fetch": now, "articles": {}})

    last_fetch = datetime.fromisoformat(seen["last_fetch"])
    new_articles = []
    for feed in config["feeds"]:
        feed_data = fetch_feed(feed["link"])
        seen_entries = seen["articles"].setdefault(feed["link"], [])
        for entry in feed_data.entries:
            if should_notify(entry, seen_entries, last_fetch):
                print(f"{now} : new article : {entry.title} - {entry.link}")
                new_article = {
                    "title": entry.title,
                    "link": entry.link,
                    "fetched": now,
                }
                new_articles.append(new_article)
                seen["articles"].setdefault(feed["link"], []).append(new_article)

    seen["last_fetch"] = now
    save_json(visited, seen)

    if len(new_articles) > 5:
        news = os.path.join(state_dir, f"{now}.json")
        save_json(news, new_articles)
        notification.notify(title="New articles!", message=f"file://{news}")

    elif len(new_articles) > 0:
        for entry in new_articles:
            notification.notify(title=entry['title'], message=entry['link'])

    print(f"{now} : found {len(new_articles)} new articles")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python script.py <state_directory>")
        sys.exit(1)

    fetch_and_notify(sys.argv[1])
