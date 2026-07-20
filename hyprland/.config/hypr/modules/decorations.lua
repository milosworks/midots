-- See https://wiki.hypr.land/Configuring/Basics/Variables/#decoration

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,

        border_size = 1,

        col = {
            active_border = "rgba(595959aa)",
            inactive_border = "rgba(333333aa)"
        }
    },

    decoration = {
        rounding = 5,
        rounding_power = 4,

        blur = {
            enabled = true,
            size = 6,
            passes = 3,
            ignore_opacity = false
        },

        shadow = {
            enabled = true,
            range = 15,
            render_power = 3,
            color = "rgba(00000099)"
        },
    }
})
