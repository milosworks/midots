hl.on("hyprland.start", function()
    -- Shell
    hl.exec_cmd("quickshell")

    -- Clipboard
    hl.exec_cmd("wl-paste --watch clipvault store --max-entries 500 --max-entry-age 7d")
    hl.exec_cmd("wl-clip-persist --clipboard regular")

    -- Wallpaper
    hl.exec_cmd("awww-daemon")

    -- Polkit authentication agent
    -- TODO: Implement own polkitagent with quickshell
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
end)
