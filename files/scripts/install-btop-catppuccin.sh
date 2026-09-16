#!/usr/bin/env bash

set -euo pipefail

readonly release_url="https://github.com/catppuccin/btop/releases/latest/download/themes.tar.gz"
readonly theme_dir="/usr/share/btop/themes"
temp_dir="$(mktemp -d)"

cleanup() {
	rm -rf "$temp_dir"
}

trap cleanup EXIT

curl --fail --silent --show-error --location --retry 3 \
	--output "$temp_dir/themes.tar.gz" \
	"$release_url"

tar --extract --gzip --file "$temp_dir/themes.tar.gz" \
	--strip-components=1 \
	--directory "$temp_dir"

install --directory "$theme_dir"
install --mode=0644 "$temp_dir"/*.theme "$theme_dir/"
