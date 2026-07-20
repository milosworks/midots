# Start the keyring
eval $(gnome-keyring-daemon --start)
export SSH_AUTH_SOCK

# Start hyprland at the start of the session
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
    exec start-hyprland
fi
