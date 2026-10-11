-- General, decoration, groups, animations, layouts, misc.

local c = require("modules.palette")

local border = { colors = { c.accent1, c.accent2 }, angle = 45 }

hl.config({
    general = {
        gaps_in          = 4,
        gaps_out         = 8,
        border_size      = 2,
        layout           = "dwindle",
        resize_on_border = true,
        allow_tearing    = false,
        col = {
            active_border   = border,
            inactive_border = c.dark,
        },
    },

    decoration = {
        rounding         = 8,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled      = true,
            range        = 14,
            render_power = 3,
            color        = "rgba(0a0a0aee)",
        },
        blur = {
            enabled           = true,
            size              = 6,
            passes            = 2,
            new_optimizations = true,
            vibrancy          = 0.1696,
        },
    },

    group = {
        col = {
            border_active   = border,
            border_inactive = c.dark,
        },
        groupbar = {
            col = {
                active   = c.accent1,
                inactive = c.dark,
            },
        },
    },

    misc = {
        force_default_wallpaper  = -1,
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
    },

    ecosystem = { no_update_news = true },

    dwindle = { preserve_split = true },
    master  = { new_status = "master" },

    animations = { enabled = true },
})

hl.curve("snappy", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })

hl.animation({ leaf = "windows",     enabled = true, speed = 7,  bezier = "snappy" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 7,  bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8,  bezier = "default" })
hl.animation({ leaf = "fade",        enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 6,  bezier = "default" })
