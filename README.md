# Zirconium

[![bluebuild build badge](https://github.com/cvsickle/zirconium/actions/workflows/build.yml/badge.svg)](https://github.com/cvsickle/zirconium/actions/workflows/build.yml) &nbsp; [![Dependabot Updates](https://github.com/cvsickle/zirconium/actions/workflows/dependabot/dependabot-updates/badge.svg)](https://github.com/cvsickle/zirconium/actions/workflows/dependabot/dependabot-updates) &nbsp; [![renovate](https://github.com/cvsickle/zirconium/actions/workflows/renovate.yml/badge.svg)](https://github.com/cvsickle/zirconium/actions/workflows/renovate.yml)

---

This repository is a custom [bootc](https://github.com/bootc-dev/bootc) image built on [Zirconium](https://github.com/zirconium-dev/zirconium).

It was created using the [BlueBuild Workshop](https://workshop.blue-build.org/).

## Changes made

### System packages added

- Everything needed for [LazyVim](https://github.com/lazyvim/lazyvim)
  - [Neovim](https://github.com/neovim/neovim)
  - [LazyGit](https://github.com/jesseduffield/lazygit)
  - JetBrains Mono Nerd Font from [ryanoasis/nerd-fonts](https://github.com/ryanoasis/nerd-fonts)
  - Etc.
- [Helium Browser](https://github.com/imputnet/helium)
- Dependencies for [Fausto-Korpsvart](https://github.com/Fausto-Korpsvart) themes.
- Swapped `tuned-ppd` for `power-profiles-daemon` for optimization on Framework 13 Pro. See the [Phoronix writeup](https://www.phoronix.com/review/fedora-pantherlake-thermald-tuned).
- Docker CLI
- Podman Compose
- VS Code
- [Oniri](https://github.com/Antiz96/oniri)

### Brew

- [Dev Container CLI](https://github.com/devcontainers/cli)
- [LazyDocker](https://github.com/jesseduffield/lazydocker)

### Flatpak

- [Easy Effects](https://flathub.org/en/apps/com.github.wwmm.easyeffects)
- [Flatseal](https://flathub.org/en/apps/com.github.tchx84.Flatseal)
- [Gear Lever](https://flathub.org/en/apps/it.mijorus.gearlever)
- [Podman Desktop](https://flathub.org/en/apps/io.podman_desktop.PodmanDesktop)
- [SiriKali](https://flathub.org/en/apps/io.github.mhogomchungu.sirikali)
- [Web Apps](https://flathub.org/en/apps/net.codelogistics.webapps)

## Installation

THere is the recommened installation process.

- Flash the Zirconium ISO from the project's [GitHub](https://isos.zirconium.gay/zirconium-isos/zirconium-amd64.iso) onto a USB.
- Boot from the USB and install Zirconium.
- Boot into Zirconium.

> [!TIP]
> This process should work from any Fedora-based bootc image.

```bash
# Switch to developer mode.
ujust devmode
# Reboot when done.
systemctl reboot
```

- Once in Zirconium, switch to this image.

```bash
# Normal image
sudo bootc switch ghcr.io/cvsickle/zirconium:latest
# Nvidia image
sudo bootc switch ghcr.io/cvsickle/zirconium-nvidia:latest

# Reboot when done.
systemctl reboot
```

- Once booted into this image, enable signing verification.

```bash
# Normal image
sudo bootc switch --enforce-container-sigpolicy ghcr.io/cvsickle/zirconium:latest
# Nvidia image
sudo bootc switch --enforce-container-sigpolicy ghcr.io/cvsickle/zirconium-nvidia:latest
```

- If the boot loader menu entries are still showing the upstream image name, force them to update.

```bash
sudo rpm-ostree kargs --append=bls.refresh=1
systemctl reboot

sudo rpm-ostree kargs --delete=bls.refresh=1
systemctl reboot
```

## Recommended GTK Theming

Want to make your apps look less gray? Check out the [theming instructions](./docs/themes.md).

## Verification

These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command:

```bash
cosign verify --key cosign.pub ghcr.io/cvsickle/zirconium
```
