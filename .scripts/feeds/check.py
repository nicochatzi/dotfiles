import json
import sys
import os
from datetime import datetime
import feedparser
import requests
from plyer import notification

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

def run(state_dir):
    visited = os.path.join(state_dir, 'seen.json')
    config = load_json('feeds.json', {'feeds': []})
    seen = load_json(visited, {'last_fetch': "", 'seen_entries': {}})

    for feed in config['feeds']:
        feed_data = fetch_feed(feed['link'])
        feed_seen = seen['seen_entries'].setdefault(feed['link'], [])

        for entry in feed_data.entries:
            if entry.link not in feed_seen:
                notification.notify(title=entry.title, message=entry.link)
                feed_seen.append(entry.link)

    seen['last_fetch'] = datetime.now().isoformat()
    save_json(visited, seen)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python feeds.py <state_directory>")
        sys.exit(1)
    run(sys.argv[1])

