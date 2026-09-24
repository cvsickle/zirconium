#!/usr/bin/env bash

sudo flatpak override --filesystem="$HOME/.themes"
sudo flatpak override --filesystem="$HOME/.icons"
sudo flatpak override --filesystem="xdg-config/gtk-4.0"
