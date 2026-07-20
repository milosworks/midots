-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- See https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Allow VRR for OW
-- hl.window_rule({
--     name = "allow-vrr-ow",
--     match = { class = "steam_app_2357570" },
--     immediate = true
-- })

-- Ignore maximize requests from all apps
hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
    suppress_event = "maximize",
    enabled        = true
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name     = "fix-xwayland-drags",
    match    = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})


-- Smart gaps, remove everything when only 1 tiled window
hl.workspace_rule({
    workspace = "w[tv1]",
    gaps_out  = 0,
    gaps_in   = 0,
    no_border = true,
    no_shadow = true,
})

-- Smart gaps, remove everything when window is maximized
hl.workspace_rule({
    workspace = "f[1]",
    gaps_out  = 0,
    gaps_in   = 0,
    no_border = true,
    no_shadow = true
})

-- Keep zen browser rendering
hl.window_rule({
    match = { class = "^(zen)$" },
    render_unfocused = true
})
