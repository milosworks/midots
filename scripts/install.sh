#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
PKG_FILE="${DOTFILES_DIR}/packages.txt"
AUR_PKG_FILE="${DOTFILES_DIR}/aur-packages.txt"
FLATPAKS_FILE="${DOTFILES_DIR}/flatpaks.txt"

echo "==> Starting package installation..."
echo "==> Updating system..."
sudo pacman -Syu --noconfirm

if [[ ! -f "$PKG_FILE" ]]; then
    echo "Error: Could not find $PKG_FILE"
    exit 1
fi

if [[ ! -f "$AUR_PKG_FILE" ]]; then
    echo "Error: Could not find $AUR_PKG_FILE"
    exit 1
fi

if [[ ! -f "$FLATPAKS_FILE" ]]; then
    echo "Error: Could not find $FLATPAKS_FILE"
    exit 1
fi

echo "==> Installing packages from packages.txt..."
grep -E -v '^\s*#|^\s*$' "$PKG_FILE" | sudo pacman -S --needed --noconfirm -

echo "==> Installing yay..."
if ! command -v yay &>/dev/null; then
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    (cd /tmp/yay-bin && makepkg -si --noconfirm)
    rm -rf /tmp/yay-bin
    echo "==> yay installed successfully!"
else
    echo "==> yay is already installed, skipping..."
fi

echo "==> installing packages from the aur..."
grep -E -v '^\s*#|^\s*$' "$AUR_PKG_FILE" | yay -S --needed --noconfirm -

echo "==> installing flatpaks..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
grep -E -v '^\s*#|^\s*$' "$FLATPAKS_FILE" | xargs -r flatpak install -y flathub

echo "==> Package installation complete!"
