#!/bin/bash

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <commit-message> <refs>"
    exit 1
fi

git commit -s -m "$1"$'\n\n'"Refs: $2"
