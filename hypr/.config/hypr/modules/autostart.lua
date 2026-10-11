-- Runs once at session start (the Lua equivalent of exec-once).
-- Host-specific extras are in hosts/<profile>/init.lua.

local monitors = require("modules.monitors")

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("quickshell")
    hl.exec_cmd("mako")
    hl.exec_cmd("swayosd-server")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")

    -- Start on the main screen when docked; a no-op if it isn't connected.
    hl.dispatch(hl.dsp.focus({ monitor = monitors.primary }))
end)
