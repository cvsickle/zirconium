#!/usr/bin/env bash

set -euo pipefail

# renovate: datasource=github-releases depName=git-ecosystem/git-credential-manager
GCM_VERSION="2.9.1"

case "$(uname -m)" in
	x86_64)
		GCM_ARCH="x64"
		GCM_SHA256="31fc151c3b111ffe25616a4356bd9a50bdcdbd0922c5e11990fb220c6caf1ce1"
		;;
	aarch64|arm64)
		GCM_ARCH="arm64"
		GCM_SHA256="cf3806b7528b5a5af16bd4bd0683202fc432d9008dd91d20c4c6744b24a033b5"
		;;
	*)
		printf 'Unsupported architecture: %s\n' "$(uname -m)" >&2
		exit 1
		;;
esac

GCM_ASSET="gcm-linux-${GCM_ARCH}-${GCM_VERSION}.tar.gz"
GCM_URL="https://github.com/git-ecosystem/git-credential-manager/releases/download/v${GCM_VERSION}/${GCM_ASSET}"
TEMPORARY_DIRECTORY="$(mktemp -d)"
trap 'rm -rf "${TEMPORARY_DIRECTORY}"' EXIT

curl --fail --location --silent --show-error --retry 3 \
	--output "${TEMPORARY_DIRECTORY}/${GCM_ASSET}" \
	"${GCM_URL}"

printf '%s  %s\n' "${GCM_SHA256}" "${TEMPORARY_DIRECTORY}/${GCM_ASSET}" \
	| sha256sum --check --status

install --directory /usr/local/bin
tar --extract --gzip --file "${TEMPORARY_DIRECTORY}/${GCM_ASSET}" \
	--directory /usr/local/bin