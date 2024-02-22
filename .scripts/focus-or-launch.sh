#!/usr/bin/env bash

WINDOW_TITLE=$1
LAUNCH_COMMAND=$2
WORKING_DIR=${3:-$HOME}

if ! i3-msg "[title=\"$WINDOW_TITLE\"] focus"; then
  eval alacritty --title "$WINDOW_TITLE" --working-directory="$WORKING_DIR" -e "$LAUNCH_COMMAND"
fi
