#!/usr/bin/env bash
set -euo pipefail

ARCH="$(uname -m)"
case "${ARCH}" in
  x86_64)
    JUST_ARCH="x86_64-unknown-linux-musl"
    COSIGN_ARCH="amd64"
    ;;
  aarch64|arm64)
    JUST_ARCH="aarch64-unknown-linux-musl"
    COSIGN_ARCH="arm64"
    ;;
  *)
    echo "Unsupported architecture: ${ARCH}" >&2
    exit 1
    ;;
esac

# Install just
# renovate: datasource=github-releases depName=casey/just
JUST_VERSION="1.58.0"
curl -fsSL \
    "https://github.com/casey/just/releases/download/${JUST_VERSION}/just-${JUST_VERSION}-${JUST_ARCH}.tar.gz" \
    | sudo tar -xz -C /usr/local/bin just
sudo tee /usr/local/bin/ujust >/dev/null <<'EOF'
#!/bin/bash
just --justfile /workspaces/bluefin-dx-nvidia-open/justfile "$@"
EOF
sudo chmod +x /usr/local/bin/ujust

# Install cosign
# renovate: datasource=github-releases depName=sigstore/cosign
COSIGN_VERSION="v3.1.3"
curl -fsSL \
    "https://github.com/sigstore/cosign/releases/download/${COSIGN_VERSION}/cosign-linux-${COSIGN_ARCH}" \
    | sudo tee /usr/local/bin/cosign >/dev/null
sudo chmod +x /usr/local/bin/cosign

# Install bluebuild CLI
# renovate: datasource=github-releases depName=blue-build/cli
BLUEBUILD_VERSION="v0.9.37"
curl -fsSL "https://raw.githubusercontent.com/blue-build/cli/${BLUEBUILD_VERSION}/install.sh" | sudo bash
command -v bluebuild
bluebuild --version
