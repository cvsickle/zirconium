#!/usr/bin/env bash

set -euo pipefail

# renovate: datasource=github-releases depName=git-ecosystem/git-credential-manager
GCM_VERSION="3.0.1"
GCM_ASSET="gcm-linux-x64-${GCM_VERSION}.tar.gz"
GCM_BASE_URL="https://github.com/git-ecosystem/git-credential-manager/releases/download/v${GCM_VERSION}"

if [[ "$(uname -m)" != "x86_64" ]]; then
	printf 'Unsupported architecture: %s\n' "$(uname -m)" >&2
	exit 1
fi

temporary_directory="$(mktemp -d)"
trap 'rm -rf "${temporary_directory}"' EXIT

# GCM does not publish .sha256 files, so take the checksum from the pinned
# release's asset digest. The API response is flattened to one line so the
# digest that follows this asset's name can be matched without a JSON parser.
expected_checksum="$(
	curl --fail --location --silent --show-error --retry 3 \
		"https://api.github.com/repos/git-ecosystem/git-credential-manager/releases/tags/v${GCM_VERSION}" \
		| tr -d '\n' \
		| grep -oP "\"name\": *\"${GCM_ASSET//./\\.}\".*?\"digest\": *\"sha256:\K[0-9a-f]{64}" \
		| head -n 1
)"
[[ "${expected_checksum}" =~ ^[[:xdigit:]]{64}$ ]]

curl --fail --location --silent --show-error --retry 3 \
	--output "${temporary_directory}/${GCM_ASSET}" \
	"${GCM_BASE_URL}/${GCM_ASSET}"

(
	cd "${temporary_directory}"
	printf '%s  %s\n' "${expected_checksum}" "${GCM_ASSET}" | sha256sum --check
)

tar --extract --gzip --file "${temporary_directory}/${GCM_ASSET}" \
	--directory /usr/bin