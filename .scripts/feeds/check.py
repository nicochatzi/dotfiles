import json
import sys
import requests
import os
from datetime import datetime, timezone
import feedparser
from plyer import notification
import subprocess


def load_json(file_path, default=None):
    if os.path.exists(file_path):
        with open(file_path, 'r') as f:
            return json.load(f)
    return default if default is not None else {}


def save_json(file_path, data):
    with open(file_path, 'w') as f:
        json.dump(data, f, indent=2)


def fetch_feed(url):
    headers = {'User-Agent': 'Mozilla/5.0'}
    response = requests.get(url, headers=headers)
    return feedparser.parse(response.content)


def get_entry_date(entry):
    if 'published_parsed' in entry and entry['published_parsed']:
        return datetime(*entry['published_parsed'][:6], tzinfo=timezone.utc)
    return datetime.now(timezone.utc)


def fetch_and_notify(state_dir):
    now = datetime.now(timezone.utc).isoformat()
    visited = os.path.join(state_dir, 'seen.json')
    config = load_json('feeds.json', {'feeds': []})
    seen = load_json(visited, {'last_fetch': now, 'articles': {}})

    last_fetch = datetime.fromisoformat(seen['last_fetch'])
    new_articles = []
    for feed in config['feeds']:
        feed_data = fetch_feed(feed['link'])
        for entry in feed_data.entries:
            date = get_entry_date(entry)
            if date <= last_fetch:
                continue
            new_article = {
                'title': entry.title,
                'link': entry.link,
                'fetched': now,
            }
            new_articles.append(new_article)
            seen['articles'].setdefault(feed['link'], []).append(new_article)

    seen['last_fetch'] = now
    save_json(visited, seen)

    if len(new_articles) > 5:
        news = os.path.join(state_dir, f'{now}.json')
        save_json(news, new_articles)
        notification.notify(title="New articles!", message=news)

    elif len(new_articles) > 0:
        notification.notify(title=entry.title, message=entry.link)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python script.py <state_directory>")
        sys.exit(1)

    fetch_and_notify(sys.argv[1])

