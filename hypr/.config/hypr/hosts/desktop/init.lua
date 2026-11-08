-- Desktop tower: two BenQs, workspace layout from modules/monitors.lua.

hl.config({
    misc   = { vrr = 2 },               -- VRR for fullscreen games only
    render = { direct_scanout = true },
})

hl.on("hyprland.start", function()
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("opendeck --hide")       -- Stream Deck; window stays in the tray
end)
