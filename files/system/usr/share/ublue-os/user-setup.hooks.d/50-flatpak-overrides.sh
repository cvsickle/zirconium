#!/usr/bin/env bash
set -euo pipefail

# Allow flatpak access to themes.
flatpak override --user \
  --filesystem="$HOME/.themes:ro" \
  --filesystem="$HOME/.local/share/themes:ro" \
  --filesystem="$HOME/.icons:ro" \
  --filesystem="$HOME/.local/share/icons:ro" \
  --env=QT_QPA_PLATFORMTHEME=kde \
  --env=PLASMA_INTEGRATION_USE_PORTAL=1 \
  --filesystem=xdg-config/gtk-3.0:ro \
  --filesystem=xdg-config/gtk-4.0:ro \
  --filesystem=xdg-config/qt6ct:ro \
  --filesystem=xdg-config/kdeglobals:ro \
  --filesystem=xdg-data/color-schemes:ro \
  --filesystem=xdg-cache/DankMaterialShell:ro

# Uninstall DankCalendar
if flatpak info com.danklinux.dankcalendar &>/dev/null; then
    echo "Removing upstream Flatpak to prioritize native package..."
    flatpak uninstall -y com.danklinux.dankcalendar
fi
