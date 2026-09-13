#!/usr/bin/env bash
set -euo pipefail

# Define packages to install
PACKAGES=(
  lazydocker
  devcontainer
)

STATE="${HOME}/.cache/.brew-default-packages"
[[ -f "$STATE" ]] && exit 0
[[ -x /home/linuxbrew/.linuxbrew/bin/brew ]] || exit 0

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

brew install "${PACKAGES[@]}"

mkdir -p "$(dirname "$STATE")"
touch "$STATE"
