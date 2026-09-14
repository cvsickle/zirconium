# Niri Setup

## Disable the "Important Hotkeys" window

To disable the hotkey cheatsheet window so that it doesn't open automatically each log in, add the following to `~/.config/niri/local.kdl`:

```txt
hotkey-overlay {
  skip-at-startup
}
```

## Enable Oniri

Oniri must be enabled in `~/.config/niri/local.kdl`. See the [Oniri Readme](https://github.com/Antiz96/oniri) for the configuration options.

The recommended option is to use Oniri in "tiling layout" mode. The first window in a workspace will get unmaximized when a second one is opened. Closing all but one window in a workspace will re-maximize the remaining window.

Add this to `~/.config/niri/local.kdl`:

```txt
spawn-sh-at-startup "oniri --tiling-layout"
```
