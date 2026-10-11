-- Laptop. Docked, the desk reads left to right: GL2480 | GL2580 | laptop
-- screen, with workspaces 1-3 | 4-6 | 7-9. Undocked, the pins to absent
-- monitors are ignored and everything lands on the built-in screen.

local monitors = require("modules.monitors")

local builtin = "eDP-1"

hl.monitor({ output = builtin, mode = "preferred", position = "3840x0", scale = 1 })

-- persistent keeps empty workspaces (and their monitor pin) alive, so the
-- 1-2-3 / 4-5-6 / 7-8-9 grid doesn't reshuffle as workspaces empty out.
monitors.pin_workspaces({
    { monitors.left,    1, 3 },
    { monitors.primary, 4, 6 },
    { builtin,          7, 9 },
}, { persistent = true })

hl.env("XCURSOR_SIZE", "22")
hl.env("HYPRCURSOR_SIZE", "22")

hl.on("hyprland.start", function()
    hl.exec_cmd("blueman-applet")
end)
