# Recommended GTK Themeing

This is the recommended method for applying themes to GTK applications.

## Installation

### Pick a theme

First, pick a theme from [Fausto-Korpsvart](https://github.com/Fausto-Korpsvart).

The dependencies for these themes are included in the image.

### Clone the desired repository

For example, the Catppuccin-GTK-Theme:

```bash
git clone https://github.com/Fausto-Korpsvart/Catppuccin-GTK-Theme
cd Catppuccin-GTK-Theme
```

### Install the theme

First, install the theme for GTK2/3.

```bash
./themes/install.sh

# Do you want to apply Vague?
# Answer: "Yes : Automatic installation"

# Which variant do you want to apply?
# Answer: "Dark : Set all themes to Dark" (unless you're a psychopath)
```

Then, install the theme for GTK4.

```bash
./themes/install.sh --libadwaita

# Same answers as the first time.
```

### Flatpak access

Allow Flatpak apps to have access to the themes.

```bash
sudo flatpak override --filesystem=$HOME/.themes
sudo flatpak override --filesystem=$HOME/.icons
sudo flatpak override --filesystem=xdg-config/gtk-4.0
```

Congratulations. Now your system is beautiful.

## Uninstallation

If you ever want to go back to the ugly GTK gray or install a different theme, just uninstall the current theme.

```bash
# GTK4
./themes/install.sh --libadwaita --uninstall

#GTK2/3
./themes/install.sh --uninstall
```
