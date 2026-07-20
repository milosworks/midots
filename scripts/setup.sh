#!/usr/bin/env bash

set -euo pipefail

echo "==> Starting system configuration..."

if [ "$SHELL" != "/usr/bin/zsh" ]; then
    echo "==> Changing default shell to zsh..."
    chsh -s /usr/bin/zsh
else
    echo "==> zsh is already the default shell."
fi

# Handling keyring
mkdir -p ~/.local/share/keyrings

git config --global credential.helper /usr/lib/git-core/git-credential-libsecret
git config --global core.editor "code --wait"

# Enabling services
echo "==> starting and enabling services."
sudo systemctl enable --now ufw.service
sudo systemctl enable --now coolercontrold

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

# for controlling displays
sudo usermod -aG i2c "$USER"

# run after stow
update-desktop-database ~/.local/share/applications/
fc-cache -fv
