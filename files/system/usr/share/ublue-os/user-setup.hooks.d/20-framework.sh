#!/usr/bin/env bash

source /usr/lib/ublue/setup-services/libsetup.sh

version-script framework tool 2 || exit 0

set -x

VEN_ID="$(cat /sys/devices/virtual/dmi/id/chassis_vendor)"

# Install framework_tool and wallpapers for Framework laptops
if [[ ":Framework:" =~ :$VEN_ID: ]]; then
    BREW_PREFIX="/home/linuxbrew/.linuxbrew"
    BREW_BIN="${BREW_PREFIX}/bin/brew"

    if [[ ! -x "$BREW_BIN" ]]; then
        echo "Warning: brew not found at $BREW_BIN, skipping Framework software installation (will retry on next run)"
    else
        if ! "$BREW_BIN" trust ublue-os/tap; then
            echo "Warning: failed to trust ublue-os/tap; Framework cask installs may fail"
        fi

        # Check if framework-tool is already installed via brew
        if ! "$BREW_BIN" list --cask framework-tool &> /dev/null; then
            echo "Framework laptop detected, installing framework-tool"
            if "$BREW_BIN" install --cask ublue-os/tap/framework-tool; then
                echo "framework-tool installed successfully"
            else
                echo "Warning: framework-tool installation failed, will retry on next run"
            fi
        else
            echo "framework-tool already installed, skipping"
        fi

        # Check if framework-wallpapers is already installed via brew
        if ! "$BREW_BIN" list --cask framework-wallpapers &> /dev/null; then
            echo "Installing Framework wallpapers"
            if "$BREW_BIN" install --cask ublue-os/tap/framework-wallpapers; then
                echo "Framework wallpapers installed successfully"
            else
                echo "Warning: framework-wallpapers installation failed, will retry on next run"
            fi
        else
            echo "Framework wallpapers already installed, skipping"
        fi

        # Check if framework-tool-tui is already installed via brew
        if ! "$BREW_BIN" list --formula framework-tool-tui &> /dev/null; then
            echo "Framework laptop detected, installing framework-tool-tui"
            if "$BREW_BIN" install framework-tool-tui; then
                echo "framework-tool-tui installed successfully"
            else
                echo "Warning: framework-tool-tui installation failed, will retry on next run"
            fi
        else
            echo "framework-tool-tui already installed, skipping"
        fi
    fi
fi
