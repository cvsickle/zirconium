# Tailscale

Tailscale is installed and setup.

## Connect

You probably want to set a specific hostname before connection.

```bash
sudo hostnamectl set-hostname your-new-hostname
```

To connect to your Tailscale network:

```bash
sudo tailscale up
```

This will give you a URL to complete the login.

## Disconnect

To disconnect.

```bash
sudo tailscale down
```

## DMS Controls

To enable the DMS widget controls, set Tailscale to run as your user.

```bash
sudo tailscale set --operator=$USER
```
