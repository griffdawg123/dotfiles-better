-- Desktop tower: two BenQs, left = 1-5, right (primary) = 6-10.

local monitors = require("modules.monitors")

monitors.pin_workspaces({
    { monitors.left,    1, 5 },
    { monitors.primary, 6, 10 },
})

hl.config({
    misc   = { vrr = 2 },               -- VRR for fullscreen games only
    render = { direct_scanout = true },
})

hl.on("hyprland.start", function()
    hl.exec_cmd("nm-applet --indicator")
end)
