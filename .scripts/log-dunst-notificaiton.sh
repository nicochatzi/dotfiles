#!/usr/bin/env bash

set -euo pipefail

logdir="$HOME/notifications"
mkdir -p "$logdir"

today="$(date +%F)"                       # 2025-05-30
ts="$(date --iso-8601=seconds)"           # 2025-05-30T17:12:34+02:00
logfile="${logdir}/${today}.jsonl"

jq -n --arg time     "$ts" \
      --arg app      "$1" \
      --arg summary  "$2" \
      --arg body     "$3" \
      --arg icon     "$4" \
      --arg urgency  "$5" \
      '{time:$time, app:$app, summary:$summary, body:$body,
        icon:$icon, urgency:$urgency}' >> "$logfile"

find "$logdir" -type f -name '*.jsonl' -mtime +31 -delete 2>/dev/null

