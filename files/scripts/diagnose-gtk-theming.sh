#!/usr/bin/env bash

set -u

report="${1:-$HOME/gtk-theme-diagnostics-$(date +%Y%m%d-%H%M%S).txt}"
report_dir="$(dirname "$report")"

if ! mkdir -p "$report_dir"; then
	printf 'Could not create report directory: %s\n' "$report_dir" >&2
	exit 1
fi

run() {
	printf '\n$'
	printf ' %q' "$@"
	printf '\n'
	"$@"
	status=$?
	printf '[exit status: %s]\n' "$status"
	return 0
}

{
	printf 'GTK/DMS theming diagnostics\n'
	printf 'Generated: %s\n' "$(date --iso-8601=seconds)"
	printf 'User: %s\n' "$(id -un)"
	if [[ "$(id -u)" -eq 0 ]]; then
		printf 'WARNING: Run this as your desktop user, not as root.\n'
	fi

	printf '\n== System ==\n'
	run cat /etc/os-release
	run uname -a

	printf '\n== DMS ==\n'
	run command -v dms
	run dms version
	run dms doctor

	printf '\n== GTK settings and environment ==\n'
	run gsettings get org.gnome.desktop.interface gtk-theme
	run gsettings get org.gnome.desktop.interface color-scheme
	printf 'DMS_ENABLE_GTK_REFRESH=%s\n' "${DMS_ENABLE_GTK_REFRESH-<unset>}"
	printf 'GTK_THEME=%s\n' "${GTK_THEME-<unset>}"

	printf '\n== Theme and Files packages ==\n'
	run rpm -q adw-gtk3-theme nwg-look nautilus
	printf '\nFlatpak Files/Nautilus matches:\n'
	flatpak list --app --columns=application,name 2>&1 |
		grep -iE 'files|nautilus' || true

	printf '\n== Theme and GTK config paths ==\n'
	for path in \
		/usr/share/themes/adw-gtk3/gtk-3.0 \
		/usr/share/themes/adw-gtk3-dark/gtk-3.0 \
		"$HOME/.local/share/themes/adw-gtk3/gtk-3.0" \
		"$HOME/.local/share/themes/adw-gtk3-dark/gtk-3.0" \
		"$HOME/.config/gtk-3.0/gtk.css" \
		"$HOME/.config/gtk-4.0/gtk.css" \
		"$HOME/.config/gtk-3.0/dank-colors.css" \
		"$HOME/.config/gtk-4.0/dank-colors.css"; do
		if [[ -L "$path" ]]; then
			printf '%s -> %s\n' "$path" "$(readlink "$path")"
			ls -ld "$path"
		elif [[ -e "$path" ]]; then
			ls -ld "$path"
		else
			printf 'MISSING %s\n' "$path"
		fi
	done

	printf '\n== User Flatpak overrides ==\n'
	run flatpak override --user --show

	printf '\n== Recent GTK/DMS user journal entries ==\n'
	journalctl --user -b --no-pager 2>&1 |
		grep -iE 'gtk|matugen|failed to apply|patcher|applier|DankMaterialShell|quickshell' |
		tail -100 || true
} >"$report" 2>&1

printf 'Diagnostics written to: %s\n' "$report"