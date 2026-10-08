#!/usr/bin/env bash

set -euo pipefail

GCM_REPOSITORY="git-ecosystem/git-credential-manager"

case "$(uname -m)" in
	x86_64)
		GCM_ARCH="x64"
		;;
	aarch64|arm64)
		GCM_ARCH="arm64"
		;;
	*)
		printf 'Unsupported architecture: %s\n' "$(uname -m)" >&2
		exit 1
		;;
esac

TEMPORARY_DIRECTORY="$(mktemp -d)"
trap 'rm -rf "${TEMPORARY_DIRECTORY}"' EXIT

# Resolve the latest release. The API response is flattened to one line so the
# tag and the per-asset digest can be matched without a JSON parser.
RELEASE_JSON="${TEMPORARY_DIRECTORY}/release.json"
curl --fail --location --silent --show-error --retry 3 \
	--output "${RELEASE_JSON}" \
	"https://api.github.com/repos/${GCM_REPOSITORY}/releases/latest"

RELEASE_FLAT="$(tr -d '\n' < "${RELEASE_JSON}")"

GCM_TAG="$(grep -oP '"tag_name": *"\K[^"]+' <<< "${RELEASE_FLAT}" | head -n 1)"
if [[ -z "${GCM_TAG}" ]]; then
	printf 'Could not determine latest GCM release tag\n' >&2
	exit 1
fi

GCM_VERSION="${GCM_TAG#v}"
GCM_ASSET="gcm-linux-${GCM_ARCH}-${GCM_VERSION}.tar.gz"

# GitHub reports a sha256 digest for each release asset. Use it to verify the
# download, so a corrupted or truncated archive is rejected.
GCM_SHA256="$(grep -oP "\"name\": *\"${GCM_ASSET//./\\.}\".*?\"digest\": *\"sha256:\K[0-9a-f]{64}" <<< "${RELEASE_FLAT}" | head -n 1)"
if [[ -z "${GCM_SHA256}" ]]; then
	printf 'Could not find sha256 digest for %s\n' "${GCM_ASSET}" >&2
	exit 1
fi

GCM_URL="https://github.com/${GCM_REPOSITORY}/releases/download/${GCM_TAG}/${GCM_ASSET}"

curl --fail --location --silent --show-error --retry 3 \
	--output "${TEMPORARY_DIRECTORY}/${GCM_ASSET}" \
	"${GCM_URL}"

printf '%s  %s\n' "${GCM_SHA256}" "${TEMPORARY_DIRECTORY}/${GCM_ASSET}" \
	| sha256sum --check --status

tar --extract --gzip --file "${TEMPORARY_DIRECTORY}/${GCM_ASSET}" \
	--directory /usr/bin