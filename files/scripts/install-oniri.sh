#!/usr/bin/env bash

set -euo pipefail

# renovate: datasource=github-releases depName=Antiz96/oniri
ONIRI_VERSION="1.3.5"
ONIRI_ASSET="oniri-${ONIRI_VERSION}-x86_64"
ONIRI_BASE_URL="https://github.com/Antiz96/oniri/releases/download/v${ONIRI_VERSION}"

temporary_directory="$(mktemp -d)"
trap 'rm -rf "${temporary_directory}"' EXIT

curl --fail --location --silent --show-error \
	--output "${temporary_directory}/${ONIRI_ASSET}" \
	"${ONIRI_BASE_URL}/${ONIRI_ASSET}"
curl --fail --location --silent --show-error \
	--output "${temporary_directory}/${ONIRI_ASSET}.sha256" \
	"${ONIRI_BASE_URL}/${ONIRI_ASSET}.sha256"

expected_checksum="$(awk '{ print $1 }' "${temporary_directory}/${ONIRI_ASSET}.sha256")"
[[ "${expected_checksum}" =~ ^[[:xdigit:]]{64}$ ]]

(
	cd "${temporary_directory}"
	printf '%s  %s\n' "${expected_checksum}" "${ONIRI_ASSET}" | sha256sum --check
)

install --mode=0755 "${temporary_directory}/${ONIRI_ASSET}" /usr/bin/oniri
