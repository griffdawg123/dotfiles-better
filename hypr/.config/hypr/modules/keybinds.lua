-- Keybinds. List them live with `hyprctl binds`.
--
--   SUPER + hjkl/arrows               move focus (crosses monitors at the edge)
--   SUPER + CTRL + hjkl/arrows        move window
--   SUPER + CTRL + SHIFT + hjkl/arrows resize window
--   SUPER + 0-9                       go to workspace (SHIFT: take window,
--                                     CTRL: send window and stay)

local p   = require("modules.programs")
local dsp = hl.dsp

local mod = "SUPER"

local function bind(keys, action, desc, opts)
    opts = opts or {}
    opts.description = desc
    return hl.bind(keys, action, opts)
end

local function set_gaps(inner, outer)
    hl.config({ general = { gaps_in = inner, gaps_out = outer } })
end

local DEFAULT_GAPS = { 4, 8 }

------------------
---- PROGRAMS ----
------------------

bind(mod .. " + Space",     dsp.exec_cmd(p.terminal),    "Open terminal")
bind(mod .. " + Return",    dsp.exec_cmd(p.terminal),    "Open terminal")
bind(mod .. " + R",         dsp.exec_cmd(p.menu),        "Open app launcher")
bind(mod .. " + B",         dsp.exec_cmd(p.browser),     "Open browser")
bind(mod .. " + E",         dsp.exec_cmd(p.emoji),       "Open emoji picker")
bind(mod .. " + SHIFT + E", dsp.exec_cmd(p.filemanager), "Open file manager")
bind(mod .. " + G",         dsp.exec_cmd(p.games),       "Open games launcher")
bind(mod .. " + X",         dsp.exec_cmd(p.power),       "Open power menu")
bind(mod .. " + SHIFT + B", dsp.exec_cmd(p.bluetooth),   "Open bluetooth manager")
bind(mod .. " + SHIFT + V", dsp.exec_cmd(p.volume),      "Open volume mixer")
bind(mod .. " + Escape",    dsp.exec_cmd("hyprlock"),    "Lock the screen")
bind(mod .. " + SHIFT + Q", dsp.exec_cmd("hyprshutdown"), "Exit Hyprland")

bind(mod .. " + Z", dsp.exec_cmd("pgrep -x hypridle >/dev/null && pkill -x hypridle || hypridle"), "Toggle idle lock/suspend")

-- Status bar: SUPER+SHIFT+W hides it and drops the gaps, SUPER+W brings both back.
bind(mod .. " + W", function()
    hl.dispatch(dsp.exec_cmd("pkill -x " .. p.bar .. "; " .. p.bar))
    set_gaps(DEFAULT_GAPS[1], DEFAULT_GAPS[2])
end, "Restart status bar and restore gaps")
bind(mod .. " + SHIFT + W", function()
    hl.dispatch(dsp.exec_cmd("pkill -x " .. p.bar))
    set_gaps(0, 0)
end, "Hide status bar and remove gaps")

bind(mod .. " + SHIFT + G",     function() set_gaps(DEFAULT_GAPS[1], DEFAULT_GAPS[2]) end, "Restore default gaps")
bind(mod .. " + SHIFT + minus", function() set_gaps(0, 0) end,                             "Remove gaps")

---------------------
---- SCREENSHOTS ----
---------------------

bind(mod .. " + SHIFT + S",     dsp.exec_cmd(p.shot_region), "Screenshot area")
bind(mod .. " + Print",         dsp.exec_cmd(p.shot_window), "Screenshot active window")
bind(mod .. " + SHIFT + Print", dsp.exec_cmd(p.shot_screen), "Screenshot active display")
bind("Print",                   dsp.exec_cmd(p.shot_region), "Screenshot area")

-------------------------
---- MEDIA / OSD ----
-------------------------

-- swayosd draws the on-screen indicator; the qs ipc calls keep the bar in sync.
local held = { locked = true, repeating = true }

local function osd(args, ipc)
    return dsp.exec_cmd("swayosd-client " .. args .. "; qs ipc call " .. ipc)
end

bind("XF86AudioRaiseVolume",  osd("--output-volume raise",       "volume volumeUpdate"),         "Raise volume", held)
bind("XF86AudioLowerVolume",  osd("--output-volume lower",       "volume volumeUpdate"),         "Lower volume", held)
bind("XF86AudioMute",         osd("--output-volume mute-toggle", "volume volumeUpdate"),         "Toggle mute",  { locked = true })
bind("XF86MonBrightnessUp",   osd("--brightness raise",          "brightness brightnessUpdate"), "Raise brightness", held)
bind("XF86MonBrightnessDown", osd("--brightness lower",          "brightness brightnessUpdate"), "Lower brightness", held)
bind("Caps_Lock", dsp.exec_cmd("swayosd-client --caps-lock"), "Show caps lock state", { release = true, locked = true })

bind("XF86AudioPlay", dsp.exec_cmd("playerctl play-pause"), "Play/pause",     { locked = true })
bind("XF86AudioNext", dsp.exec_cmd("playerctl next"),       "Next track",     { locked = true })
bind("XF86AudioPrev", dsp.exec_cmd("playerctl previous"),   "Previous track", { locked = true })

----------------
---- WINDOW ----
----------------

bind(mod .. " + Q", dsp.window.close(),                            "Close window")
bind(mod .. " + V", dsp.window.float(),                            "Toggle floating")
bind(mod .. " + M", dsp.window.fullscreen({ mode = "maximized" }), "Toggle maximize")
bind(mod .. " + F", dsp.window.fullscreen(),                       "Toggle fullscreen")
bind(mod .. " + Y", dsp.window.pin(),                              "Pin window to all workspaces")
bind(mod .. " + S", dsp.layout("togglesplit"),                     "Toggle split direction")

bind(mod .. " + T",   dsp.group.toggle(), "Toggle window group")
bind(mod .. " + Tab", dsp.group.next(),   "Next window in group")

bind("ALT + Tab", function()
    hl.dispatch(dsp.window.cycle_next())
    hl.dispatch(dsp.window.bring_to_top())
end, "Cycle windows")

bind(mod .. " + mouse:272", dsp.window.drag(),   "Drag window",   { mouse = true })
bind(mod .. " + mouse:273", dsp.window.resize(), "Resize window", { mouse = true })

local STEP = 15
local dirs = {
    { arrow = "left",  vim = "h", dir = "left",  dx = -STEP, dy = 0 },
    { arrow = "right", vim = "l", dir = "right", dx =  STEP, dy = 0 },
    { arrow = "up",    vim = "k", dir = "up",    dx = 0,     dy = -STEP },
    { arrow = "down",  vim = "j", dir = "down",  dx = 0,     dy =  STEP },
}

for _, d in ipairs(dirs) do
    local resize = dsp.window.resize({ x = d.dx, y = d.dy, relative = true })

    for _, key in ipairs({ d.arrow, d.vim }) do
        bind(mod .. " + " .. key,                dsp.focus({ direction = d.dir }),       "Focus " .. d.dir)
        bind(mod .. " + CTRL + " .. key,         dsp.window.move({ direction = d.dir }), "Move window " .. d.dir)
        bind(mod .. " + CTRL + SHIFT + " .. key, resize, "Resize " .. d.dir, { repeating = true })
    end
end

-- Resize mode: arrows/hjkl resize until Escape.
bind(mod .. " + SHIFT + R", dsp.submap("resize"), "Enter resize mode")
hl.define_submap("resize", function()
    for _, d in ipairs(dirs) do
        local resize = dsp.window.resize({ x = d.dx, y = d.dy, relative = true })
        bind(d.arrow, resize, "Resize " .. d.dir, { repeating = true })
        bind(d.vim,   resize, "Resize " .. d.dir, { repeating = true })
    end
    bind("Escape", dsp.submap("reset"), "Exit resize mode")
end)

--------------------
---- WORKSPACES ----
--------------------

for ws = 1, 10 do
    local key = tostring(ws % 10)
    bind(mod .. " + " .. key,         dsp.focus({ workspace = ws }),                       "Go to workspace " .. ws)
    bind(mod .. " + SHIFT + " .. key, dsp.window.move({ workspace = ws, follow = true }),  "Move window to workspace " .. ws)
    bind(mod .. " + CTRL + " .. key,  dsp.window.move({ workspace = ws, follow = false }), "Send window to workspace " .. ws)
end

-- Cycle through workspaces that have windows (empty ones are skipped).
bind(mod .. " + period",     dsp.focus({ workspace = "e+1" }),      "Next open workspace")
bind(mod .. " + comma",      dsp.focus({ workspace = "e-1" }),      "Previous open workspace")
bind(mod .. " + mouse_down", dsp.focus({ workspace = "e+1" }),      "Next open workspace")
bind(mod .. " + mouse_up",   dsp.focus({ workspace = "e-1" }),      "Previous open workspace")
bind(mod .. " + slash",      dsp.focus({ workspace = "previous" }), "Back to the last workspace")

-- Scratchpads.
bind(mod .. " + minus", dsp.window.move({ workspace = "special:magic", follow = false }), "Send window to scratchpad")
bind(mod .. " + equal", dsp.workspace.toggle_special("magic"),                            "Toggle scratchpad")
bind(mod .. " + F1",    dsp.workspace.toggle_special("scratchpad"),                       "Toggle second scratchpad")
bind(mod .. " + ALT + SHIFT + F1", dsp.window.move({ workspace = "special:scratchpad", follow = false }), "Send window to second scratchpad")
