#!/usr/bin/env bash

flatpak override --user \
  --filesystem="$HOME/.themes" \
  --filesystem="$HOME/.icons" \
  --filesystem=xdg-config/gtk-4.0
