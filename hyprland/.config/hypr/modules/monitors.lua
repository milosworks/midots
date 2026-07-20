-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

hl.monitor({
    output = "DP-1",
    mode = "2560x1440@180.00",
    position = "0x0",
    scale = 1,
    vrr = 2
})

hl.monitor({
    output = "HDML-A-2",
    mode = "1920x1080@74.97",
    position = "-1920x285",
    scale = 1
})

hl.config({
    xwayland = {
        force_zero_scaling = true
    }
})
