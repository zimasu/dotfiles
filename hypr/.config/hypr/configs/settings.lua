hl.config({
    input = {
        kb_layout = "de",
        follow_mouse = 1,
        touchpad = {
            natural_scroll = false,
        },
    },
    misc = {
        disable_splash_rendering = true,
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
    }
})

-- FIXED: Nested coordinate tables for the bezier points
hl.curve("snappy", { type = "bezier", points = { {0.16, 1}, {0.3, 1} } })

hl.animation({ leaf = "global",     enabled = false })
hl.animation({ leaf = "windowsIn",  enabled = true, speed = 1.8, bezier = "snappy" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.2, bezier = "snappy" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 2,   bezier = "snappy" })
hl.animation({ leaf = "layers",      enabled = false })
hl.animation({ leaf = "fade",        enabled = true, speed = 2.5, bezier = "snappy" })
hl.animation({ leaf = "border",      enabled = true, speed = 3,   bezier = "snappy" })
