#!/usr/bin/env bash

set -e
DUB_LOCK_FILE=$(realpath "$(dirname "$0")/../nix/dub-lock.json")

CURRENT_DUB_LOCK=$(cat $DUB_LOCK_FILE)

DUB_LOCK=$(dub-to-nix)

if [ "$CURRENT_DUB_LOCK" == "$DUB_LOCK" ]; then
    echo "dub lock is up to date"
    exit 0
elif [ "$1" != "--update" ]; then
    echo "Vendor hashes do not match, rerun with --update"
    exit 1
fi

echo $DUB_LOCK > $DUB_LOCK_FILE
