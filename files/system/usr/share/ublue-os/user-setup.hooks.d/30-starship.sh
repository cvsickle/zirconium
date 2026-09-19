#!/usr/bin/env bash

STARSHIP_CONFIG="$HOME/.config/starship.toml"

if [[ -e "$STARSHIP_CONFIG" || -L "$STARSHIP_CONFIG" ]]; then
    exit 0
fi

mkdir -p "${STARSHIP_CONFIG%/*}"
install -m 0644 /usr/share/cvsickle/starship.toml "$STARSHIP_CONFIG"
