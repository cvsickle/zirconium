#!/usr/bin/env bash
set -euo pipefail

# User-scope Flatpaks installed by default. These are installed per-user (not
# system-wide) so they can be uninstalled without root.
APPS=(
  io.github.mhogomchungu.sirikali # GUI for managing encrypted volumes
  org.gnome.FileRoller # Archive manager
  org.localsend.localsend_app # Local file sharing app
  org.gnome.Papers # PDF reader
  org.gnome.Loupe # Image viewer
  io.github.celluloid_player.Celluloid # Video player
  io.github.screwys.Rufin # Audio player
  org.gnome.Calculator # Calculator
)

STATE="${HOME}/.cache/.flatpak-default-apps"
[[ -f "$STATE" ]] && exit 0
command -v flatpak >/dev/null || exit 0

flatpak install --user --noninteractive flathub "${APPS[@]}"

mkdir -p "$(dirname "$STATE")"
touch "$STATE"
