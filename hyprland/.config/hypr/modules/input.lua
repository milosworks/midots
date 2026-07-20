-- See https://wiki.hypr.land/Configuring/Basics/Variables/#input

hl.config({
    input = {
        -- Keyboard
        kb_layout = "us,latam",
        kb_options = "grp:win_space_toggle",

        repeat_rate = 50,
        repeat_delay = 250,

        -- Mouse
        follow_mouse = 1,
        focus_on_close = 1,

        sensitivity = 0,
        accel_profile = "flat",
        force_no_accel = true
    }
})
