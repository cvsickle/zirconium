#!/usr/bin/env bash

source /usr/lib/ublue/setup-services/libsetup.sh

FRAMEWORK_TOOLS_VERSION=1

set -x

VEN_ID="$(cat /sys/devices/virtual/dmi/id/chassis_vendor)"
[[ ":Framework:" =~ :$VEN_ID: ]] || exit 0

BREW_BIN="/home/linuxbrew/.linuxbrew/bin/brew"
if [[ ! -x "$BREW_BIN" ]]; then
    echo "Warning: brew not found at $BREW_BIN; Framework tools will be retried on the next system setup"
    exit 0
fi

run_brew() {
    run0 -u linuxbrew "$BREW_BIN" "$@"
}

framework_tools_installed() {
    run_brew list --cask framework-tool &> /dev/null &&
        run_brew list --formula framework-tool-tui &> /dev/null
}

if framework_tools_installed; then
    version-script framework-tools system "$FRAMEWORK_TOOLS_VERSION" || exit 0
fi

if ! run_brew trust ublue-os/tap; then
    echo "Warning: failed to trust ublue-os/tap; framework-tool may fail to install"
fi

if ! run_brew list --cask framework-tool &> /dev/null; then
    echo "Installing framework-tool"
    if run_brew install --cask ublue-os/tap/framework-tool; then
        echo "framework-tool installed successfully"
    elif run_brew list --cask framework-tool &> /dev/null; then
        echo "framework-tool is installed despite brew returning a nonzero status"
    else
        echo "Warning: framework-tool installation failed; it will be retried on the next system setup"
    fi
else
    echo "framework-tool already installed, skipping"
fi

if ! run_brew list --formula framework-tool-tui &> /dev/null; then
    echo "Installing framework-tool-tui"
    if run_brew install framework-tool-tui; then
        echo "framework-tool-tui installed successfully"
    elif run_brew list --formula framework-tool-tui &> /dev/null; then
        echo "framework-tool-tui is installed despite brew returning a nonzero status"
    else
        echo "Warning: framework-tool-tui installation failed; it will be retried on the next system setup"
    fi
else
    echo "framework-tool-tui already installed, skipping"
fi

if framework_tools_installed; then
    version-script framework-tools system "$FRAMEWORK_TOOLS_VERSION" || true
fi