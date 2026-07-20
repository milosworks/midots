-- See https://wiki.hypr.land/Configuring/Basics/Variables/#misc
-- See https://wiki.hypr.land/Configuring/Basics/Variables/#render

hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        disable_splash_rendering = true
    },

    render = {
        direct_scanout = true
    },

    debug = {
        disable_scale_checks = true
    }
})
