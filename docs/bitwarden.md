# Bitwarden

I had to jump through a couple of hoops to get Bitwarden working with fingerprint authentication.

## Flatpak

If the Bitwarden flatpak is installed, it will use `com.bitwarden.Bitwarden.policy` that is baked into the image.

This should be enough to get fingerprint unlocking to work, so long as "Unlock with system authentication" is toggled on in the app settings.

> [!NOTE]
> The master password or pin will always be required the first time the app is opened.

## Helium browser extension

The Helium browser extension struggles to find the Flatpak app, which is required for the fingerprint authentication to work.

I tried to compile the commands required to get this working in the [setup-bitwarden-helium-biometrics](/files/scripts/setup-bitwarden-helium-biometrics.sh) script.

> [!NOTE]
> This script was compiled by an LLM after a series of successful commands. YMMV.
