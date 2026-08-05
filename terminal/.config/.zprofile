eval $(gnome-keyring-daemon --start)
export SSH_AUTH_SOCK

if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
    if uwsm check may-start; then
        exec uwsm start hyprland.desktop
    fi
fi
