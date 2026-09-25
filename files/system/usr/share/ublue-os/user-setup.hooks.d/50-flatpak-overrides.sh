#!/usr/bin/env bash
set -euo pipefail

# Allow flatpak access to themes.
flatpak override --user \
  --filesystem="$HOME/.themes" \
  --filesystem="$HOME/.icons" \
  --filesystem=xdg-config/gtk-4.0 \
  --filesystem=xdg-cache/DankMaterialShell:ro

# Uninstall DankCalendar
if flatpak info com.danklinux.dankcalendar &>/dev/null; then
    echo "Removing upstream Flatpak to prioritize native package..."
    flatpak uninstall -y com.danklinux.dankcalendar
fi
