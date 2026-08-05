hl.on("hyprland.start", function()
    -- Shell
    hl.exec_cmd("uwsm app -- quickshell")

    -- Clipboard
    hl.exec_cmd("uwsm app -- wl-paste --watch clipvault store --max-entries 500 --max-entry-age 7d")
    hl.exec_cmd("uwsm app -- wl-clip-persist --clipboard regular")

    -- Wallpaper
    hl.exec_cmd("uwsm app -- awww-daemon")

end)
