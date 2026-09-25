# DMS Greeter Setup on Zirconium

This guide was written by an LLM after some troubleshooting. YMMV. It covers three optional setup steps for the DankMaterialShell (DMS) greeter, the login screen you see at boot:

1. **Sync your theme to the login screen** so it matches your desktop
2. **Turn on "Use system PAM authentication"** so login works the way this image intends
3. **Enroll a fingerprint** for `sudo` and password prompts after you log in

On this image, the login screen **always asks for your password**. Your fingerprint works *after* you log in, for things like `sudo`, admin prompts and Bitwarden.

---

## Why `dms-greeter sync` doesn't work here

The DMS docs say to run `dms-greeter sync` to set up the greeter. On Zirconium it currently fails with an error like this:

```txt
FATAL go: Error syncing greeter: failed to ensure greeter cache directory at
/var/cache/dms-greeter: failed to apply SELinux context to /var/cache/dms-greeter:
exit status 203
```

**What's happening:** Part of the sync sets an SELinux security label on `/var/cache/dms-greeter`. The helper program it uses for that step fails to run on this image. Exit status 203 usually means the program couldn't be started at all. Because the sync stops at that step, nothing after it runs.

**Why you don't need it:** The sync is mostly a shortcut for a few simple commands. You can run those commands yourself (see Step 1). The other thing the sync does is write the login screen's authentication file. This image already includes that file, so you don't need the sync for it either.

**Why the default links point somewhere else:** Out of the box, Zirconium points the greeter at its own default settings in `/usr/share/zirconium/zdots/`. That's why `dms-greeter status` may report "symlink points to wrong location." Nothing is broken. Your login screen is just using Zirconium's defaults instead of your personal theme.

---

## Step 1: Sync your theme to the login screen (optional)

**Why you might want this:** By default, the login screen uses Zirconium's stock look. If you've changed your DMS theme, colors or wallpaper and want the login screen to match, run these commands once. The links point to your live settings, so future theme and wallpaper changes show up on the login screen automatically.

**Skip this if:** you're happy with the default login screen look.

### 1a. Add yourself to the `greeter` group

The login screen runs as a special `greeter` user. Joining this group lets it read your theme files.

```bash
sudo usermod -aG greeter "$USER"
```

### 1b. Let the greeter reach your config folders

This lets the greeter pass through your home folders to reach the DMS files. It can't list or read anything else in them.

```bash
setfacl -m u:greeter:x ~ ~/.config ~/.local ~/.cache ~/.local/state
```

### 1c. Let the greeter read your DMS settings

```bash
sudo chgrp -R greeter ~/.config/DankMaterialShell ~/.local/state/DankMaterialShell ~/.cache/DankMaterialShell
sudo chmod -R g+rX ~/.config/DankMaterialShell ~/.local/state/DankMaterialShell ~/.cache/DankMaterialShell
```

### 1d. Point the greeter at your settings

This replaces Zirconium's default links with links to your own files.

```bash
sudo mkdir -p /var/cache/dms-greeter
sudo ln -sf ~/.config/DankMaterialShell/settings.json /var/cache/dms-greeter/settings.json
sudo ln -sf ~/.local/state/DankMaterialShell/session.json /var/cache/dms-greeter/session.json
sudo ln -sf ~/.cache/DankMaterialShell/dms-colors.json /var/cache/dms-greeter/colors.json
```

| Link | What it controls |
| --- | --- |
| `settings.json` | Theme, clock, weather, fonts |
| `session.json` | Wallpaper |
| `colors.json` | Color scheme |

> **Note:** The official DMS docs use `~/.cache/quickshell/dankshell/dms-colors.json` for the colors file. The DMS version on this image uses `~/.cache/DankMaterialShell/dms-colors.json`, which is the path `dms-greeter status` expects.

### 1e. Log out and back in

Your new group membership only takes effect after you log out and back in.

### 1f. Check that it worked

```bash
dms-greeter status
```

All three links should show **synced correctly**.

---

## Step 2: Turn on "Use system PAM authentication" (recommended)

**Why you might want this:** This image includes its own login screen authentication file (`/etc/pam.d/greetd`). That file requires a password at the login screen and does not accept a fingerprint there. The DMS setting tells DMS to leave that file alone.

**If this setting is off:**

- DMS expects to manage the login screen's authentication itself, and its fingerprint toggle can give confusing results. For example, it might ask for your password *and* your fingerprint.
- Logging in with only a fingerprint leaves your keyring locked, because no password was entered. You'll then get an extra password prompt right after logging in.

### How to turn it on

1. Open **DMS Settings → Greeter**
2. Turn on **Use system PAM authentication**

When this is on, the **Fingerprint at login** toggle is greyed out. That's expected, because the image's own authentication file now decides how you log in.

> **Tip:** With this setting on, you may need to press **Enter** on the empty password field before the login screen starts asking for your password.

### Check it (optional)

```bash
grep substack /etc/pam.d/greetd
```

This should print `password-auth`. If it says `system-auth`, see Troubleshooting below.

---

## Step 3: Enroll a fingerprint (optional)

**Why you might want this:** After you log in, you can use your fingerprint instead of typing your password for `sudo`, admin prompts and apps that use system authentication, such as Bitwarden. Fingerprint support is already set up in the image, but each person has to enroll their own finger.

**Skip this if:** your computer doesn't have a fingerprint reader, or you'd rather always type your password.

### Enroll a finger

```bash
fprintd-enroll
```

Follow the prompts and touch the reader several times until enrollment finishes.

To enroll a specific finger:

```bash
fprintd-enroll -f right-thumb
```

### Confirm it worked

```bash
fprintd-list "$USER"
```

### Test it

```bash
sudo -k && sudo true
```

You should be asked for your fingerprint. The login screen will still ask for your password, which is how this image is meant to work.

### If you see "No devices available"

Your fingerprint reader probably isn't supported by `libfprint`, the fingerprint driver library. Check the libfprint supported devices list. Some Validity/Synaptics readers need a separate driver, such as `open-fprintd` with `python-validity`.

---

## Troubleshooting

### The login screen still accepts a fingerprint, or asks for both a password and a fingerprint

Your computer may have an old, locally edited copy of `/etc/pam.d/greetd` from before you updated the image. bootc keeps local edits to `/etc` instead of replacing them. Check with:

```bash
sudo ostree admin config-diff | grep greetd
```

If `greetd` shows up as modified (`M`), restore the image's version:

```bash
sudo cp /usr/etc/pam.d/greetd /etc/pam.d/greetd
```

Then make sure Step 2 is done.

### My theme changes don't show up on the login screen

Run `dms-greeter status`. If the links are fine but a new wallpaper doesn't appear, the wallpaper may be in a folder the greeter can't read. Move it into a folder that's already accessible, or give the `greeter` group read access to the new folder.

---

## Quick Summary

| Step | Needed? | What it does |
| --- | --- | --- |
| Skip `dms-greeter sync` | — | Fails on this image because of an SELinux labeling error. The steps above replace it. |
| 1. Sync your theme | Optional | Makes the login screen match your desktop theme and wallpaper |
| 2. Use system PAM authentication | Recommended | Keeps the login screen password-only and prevents extra password prompts after login |
| 3. Enroll a fingerprint | Optional | Lets you use your fingerprint for `sudo`, admin prompts and Bitwarden after login |
