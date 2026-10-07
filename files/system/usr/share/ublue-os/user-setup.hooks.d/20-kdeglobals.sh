#!/usr/bin/env bash

# Qt apps using the KDE platform theme (QT_QPA_PLATFORMTHEME=kde) read colors
# from ~/.config/kdeglobals. Link it to the DMS-generated scheme. The link is
# relative so it also resolves inside the Flatpak sandbox.
KDEGLOBALS="$HOME/.config/kdeglobals"

if [[ -e "$KDEGLOBALS" || -L "$KDEGLOBALS" ]]; then
    exit 0
fi

mkdir -p "${KDEGLOBALS%/*}"
ln -s ../.local/share/color-schemes/DankMatugen.colors "$KDEGLOBALS"
