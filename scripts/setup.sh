#!/usr/bin/env bash

set -euo pipefail

echo "==> Starting system configuration..."

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$DOTFILES_DIR"

if [ "$SHELL" != "/usr/bin/zsh" ]; then
    echo "==> Changing default shell to zsh..."
    chsh -s /usr/bin/zsh
else
    echo "==> zsh is already the default shell."
fi

# Handling keyring
mkdir -p ~/.local/share/keyrings

# auto unlock keyring on tty login
PAM_FILE="/etc/pam.d/login"

# check if gnome_keyring is already configured to prevent duplicate entries
if ! grep -q "pam_gnome_keyring.so" "$PAM_FILE"; then
    echo "Configuring GNOME Keyring auto-unlock in PAM..."

    sudo sed -i '/^auth *include *system-local-login/a auth       optional     pam_gnome_keyring.so' "$PAM_FILE"
    sudo sed -i '/^password *include *system-local-login/a password   optional     pam_gnome_keyring.so    use_authtok' "$PAM_FILE"
    sudo sed -i '/^session *include *system-local-login/a session    optional     pam_gnome_keyring.so    auto_start' "$PAM_FILE"

    echo "PAM configuration updated successfully."
else
    echo "GNOME Keyring PAM configuration already exists. Skipping."
fi

# git config
git config --global credential.helper /usr/lib/git-core/git-credential-libsecret
git config --global core.editor "code --wait"

# Enabling services
echo "==> starting and enabling services."
sudo systemctl enable --now ufw.service
sudo systemctl enable --now coolercontrold
systemctl --user enable --now hyprpolkitagent.service

# firewall
echo "==> setting up firewall"
sudo ufw --force reset

# deny all incoming
sudo ufw default deny incoming
sudo ufw default allow outgoing

# automatically get local subnet and trust it
LOCAL_SUBNET=$(ip route | grep 'proto kernel' | awk '{print $1}' | head -n 1)

if [ -n "$LOCAL_SUBNET" ]; then
    echo "==> Trusting local network: $LOCAL_SUBNET"
    sudo ufw allow from "$LOCAL_SUBNET"
else
    echo "==> Warning: Could not detect local subnet. Skipping local trust rule."
fi

sudo ufw --force enable

stow hyprland matugen mise quickshell steam terminal uwsm xdg

# run after stow
mkdir -p ~/.local/share/applications/
update-desktop-database ~/.local/share/applications/
fc-cache -fv
