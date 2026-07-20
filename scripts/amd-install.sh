#!/usr/bin/env bash

set -euo pipefail

echo "==> Starting AMD hardware driver installation..."

AMD_DRIVERS=(
    "mesa"
    "lib32-mesa"
    "vulkan-radeon"
    "lib32-vulkan-radeon"
    "libva-mesa-driver"
    "mesa-vdpau"
)

# check and handle the multilib repository
# grep looks for a line starting with exactly [multilib] (ignoring spaces)
if grep -qE '^\s*\[multilib\]' /etc/pacman.conf; then
    echo "==> [multilib] repository is already enabled."
    MULTILIB_ENABLED=true
else
    echo "==> [multilib] repository is NOT enabled."
    # temporarily disable exit-on-error for the read prompt just in case of EOF
    set +e
    read -p "Do you want to enable multilib (required for Steam/32-bit games)? [y/N] " -n 1 -r REPLY
    echo ""
    set -e
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "==> Enabling multilib in /etc/pacman.conf..."
        sudo sed -i '/^#\[multilib\]/{s/^#//;n;s/^#//}' /etc/pacman.conf
        
        echo "==> Syncing pacman databases..."
        sudo pacman -Sy
        MULTILIB_ENABLED=true
    else
        echo "==> Skipping multilib configuration."
        MULTILIB_ENABLED=false
    fi
fi

# install the base 64-bit drivers
echo "==> Installing 64-bit AMD GPU drivers..."
sudo pacman -S --needed --noconfirm "${AMD_DRIVERS[@]}"

# install 32-bit drivers if multilib is active
if [ "$MULTILIB_ENABLED" = true ]; then
    echo "==> Installing 32-bit AMD GPU drivers..."
    sudo pacman -S --needed --noconfirm lib32-mesa lib32-vulkan-radeon
fi

echo "==> Driver installation complete!"