# MiDots (Milo's Dotfiles) + MiSh (Milo's Shell)

These dotfiles provide an installation and setup script, also this guide provides some specific things to do when installing a brand new arch system (for me)

## Installation & Setup

Run the scripts in the `/scripts` folder

- `./dotfiles/script/install.sh`
  and
- `./dotfiles/script/setup.sh`

## Arch Install Guide

**Note: This guide primarily focuses on Secure Boot and our specific Dotfiles/TTY setup. For the general installation, please refer to the [Arch Wiki Installation Guide](https://wiki.archlinux.org/title/Installation_guide).**

**Warning: If you are using secure-boot (which you should) your motherboard must be on setup mode**

### Secure boot

Just before rebooting and installing and setting up [systemd-boot](https://wiki.archlinux.org/title/Systemd-boot) continue with **sbctl**

1. Verify setup mode with: `sbctl status` it should output _Setup Mode: ✔ Enabled_
2. Generate your keys with: `sbctl create-keys`
3. Enroll your keys using the `-m` flag to include Microsofts keys for dual-boot to work and still recommended for some GPU drivers
4. Sign the kernel and bootloader running
    - `sbctl sign -s /boot/vmlinuz-linux-zen`
    - `sbctl sign -s /boot/EFI/BOOT/BOOTX64.EFI`
    - Also important to run this bc of systemd-boot: `sbctl sign -s -o /usr/lib/systemd/boot/efi/systemd-bootx64.efi.signed /usr/lib/systemd/boot/efi/systemd-bootx64.efi`

### Auto-login

Setup auto-login before rebooting too running `sudo systemctl edit getty@tty1` and pasting

```
[Service]
ExecStart=
ExecStart=-/sbin/agetty -o '-p -f -- \\u' --noclear --autologin milo %I $TERM
```

The [.zprofile](/terminal/.config/.zprofile) included in these dotfiles starts Hyprland automatically on login using [UWSM (Universal Wayland Session Manager)](https://wiki.archlinux.org/title/Universal_Wayland_Session_Manager).
### Github setup

Generate a new ssh key with `ssh-keygen -t ed25519` and run `gh auth login`, then add the key to your github account
