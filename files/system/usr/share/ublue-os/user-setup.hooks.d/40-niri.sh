#!/usr/bin/env bash

NIRI_CONFIG="$HOME/.config/niri/local.kdl"

if [[ -e "$NIRI_CONFIG" || -L "$NIRI_CONFIG" ]]; then
    exit 0
fi

mkdir -p "${NIRI_CONFIG%/*}"
install -m 0644 /usr/share/cvsickle/niri/local.kdl "$NIRI_CONFIG"
