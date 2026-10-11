-- Laptop.
--
-- Docked: the desk screens use the shared layout (left = 1, primary =
-- 2-10) and the laptop screen always shows the scratchpad, so SUPER+minus
-- sends a window straight to it.
-- Undocked: a plain single screen, starting on workspace 1.

local monitors = require("modules.monitors")

local BUILTIN    = "eDP-1"
local SCRATCHPAD = "magic"   -- the special workspace SUPER+minus/equal use

hl.monitor({ output = BUILTIN, mode = "preferred", position = "3840x0", scale = 1 })

hl.env("XCURSOR_SIZE", "22")
hl.env("HYPRCURSOR_SIZE", "22")

local function builtin()
    return hl.get_monitor(BUILTIN)
end

local function docked()
    return #hl.get_monitors() > 1 and builtin() ~= nil
end

local function scratchpad_shown(mon)
    local special = mon.active_special_workspace
    return special ~= nil and special.name == "special:" .. SCRATCHPAD
end

-- Open the scratchpad on the laptop screen. toggle_special acts on the
-- focused monitor, so hop there and back.
local function show_scratchpad(mon)
    if scratchpad_shown(mon) then return end
    local back = hl.get_active_monitor()
    hl.dispatch(hl.dsp.focus({ monitor = BUILTIN }))
    hl.dispatch(hl.dsp.workspace.toggle_special(SCRATCHPAD))
    if back and back.name ~= BUILTIN then
        hl.dispatch(hl.dsp.focus({ monitor = back.name }))
    end
end

local function arrange()
    local mon = builtin()
    if not mon then return end

    if not docked() then
        -- Undocked, Hyprland has already pulled every workspace onto the
        -- laptop screen; close the docked-mode scratchpad and land on 1.
        if scratchpad_shown(mon) then
            hl.dispatch(hl.dsp.focus({ monitor = BUILTIN }))
            hl.dispatch(hl.dsp.workspace.toggle_special(SCRATCHPAD))
        end
        hl.dispatch(hl.dsp.focus({ workspace = 1 }))
        return
    end

    -- Send 1-10 back to the desk screens if they were open on the laptop.
    -- Each move makes that workspace active on its new screen, so the one
    -- you were on goes last and stays in front.
    local current = mon.active_workspace and mon.active_workspace.id
    local order = {}
    for ws = 1, 10 do
        if ws ~= current then order[#order + 1] = ws end
    end
    if current and current >= 1 and current <= 10 then
        order[#order + 1] = current
    end

    for _, ws in ipairs(order) do
        local w = hl.get_workspace(ws)
        if w and w.monitor and w.monitor.name == BUILTIN then
            hl.dispatch(hl.dsp.workspace.move({ workspace = ws, monitor = monitors.home_of(ws) }))
        end
    end

    -- The laptop screen needs a regular workspace under the scratchpad;
    -- give it one outside 1-10 so it never takes a numbered slot.
    local active = mon.active_workspace
    if not active or (active.id >= 1 and active.id <= 10) then
        local back = hl.get_active_monitor()
        hl.dispatch(hl.dsp.focus({ monitor = BUILTIN }))
        hl.dispatch(hl.dsp.focus({ workspace = "name:laptop" }))
        if back and back.name ~= BUILTIN then
            hl.dispatch(hl.dsp.focus({ monitor = back.name }))
        end
    end

    show_scratchpad(mon)
    hl.dispatch(hl.dsp.focus({ monitor = monitors.primary }))
end

-- Monitors arrive one event at a time when docking; settle, then arrange once.
local pending = false
local function arrange_soon()
    if pending then return end
    pending = true
    hl.timer(function()
        pending = false
        arrange()
    end, { timeout = 500, type = "oneshot" })
end

hl.on("hyprland.start", function()
    hl.exec_cmd("blueman-applet")
    arrange_soon()
end)
hl.on("monitor.added", arrange_soon)
hl.on("monitor.removed", arrange_soon)

-- Docked, SUPER+equal jumps to the scratchpad on the laptop screen
-- instead of toggling it onto whichever screen has focus.
hl.unbind("SUPER + equal")
hl.bind("SUPER + equal", function()
    local mon = builtin()
    if mon and docked() then
        show_scratchpad(mon)
        hl.dispatch(hl.dsp.focus({ monitor = BUILTIN }))
    else
        hl.dispatch(hl.dsp.workspace.toggle_special(SCRATCHPAD))
    end
end, { description = "Scratchpad (on the laptop screen when docked)" })
