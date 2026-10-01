#!/usr/bin/env bash

source /usr/lib/ublue/setup-services/libsetup.sh

version-script framework tool 2 || exit 0

set -x

VEN_ID="$(cat /sys/devices/virtual/dmi/id/chassis_vendor)"

# Install framework_tool and wallpapers for Framework laptops
if [[ ":Framework:" =~ :$VEN_ID: ]]; then
    BREW_PREFIX="/home/linuxbrew/.linuxbrew"

    # Check if Homebrew is available and user has write permissions
    if command -v brew &> /dev/null && [[ -w "$BREW_PREFIX" ]]; then
        if ! brew trust ublue-os/tap; then
            echo "Warning: failed to trust ublue-os/tap; Framework cask installs may fail"
        fi

        # Check if framework_tool is already installed via brew
        if ! brew list --cask framework_tool &> /dev/null; then
            echo "Framework laptop detected, installing framework_tool"
            if brew install --cask ublue-os/tap/framework_tool; then
                echo "framework_tool installed successfully"
            else
                echo "Warning: framework_tool installation failed, will retry on next run"
            fi
        else
            echo "framework_tool already installed, skipping"
        fi

        # Check if framework-wallpapers is already installed via brew
        if ! brew list --cask framework-wallpapers &> /dev/null; then
            echo "Installing Framework wallpapers"
            if brew install --cask ublue-os/tap/framework-wallpapers; then
                echo "Framework wallpapers installed successfully"
            else
                echo "Warning: framework-wallpapers installation failed, will retry on next run"
            fi
        else
            echo "Framework wallpapers already installed, skipping"
        fi

        # Check if framework-tool-tui is already installed via brew
        if ! brew list --formula framework-tool-tui &> /dev/null; then
            echo "Framework laptop detected, installing framework-tool-tui"
            if brew install framework-tool-tui; then
                echo "framework-tool-tui installed successfully"
            else
                echo "Warning: framework-tool-tui installation failed, will retry on next run"
            fi
        else
            echo "framework-tool-tui already installed, skipping"
        fi
    else
        echo "Warning: brew not found or user lacks write permission to $BREW_PREFIX, skipping Framework software installation (will retry when available)"
    fi
fi
