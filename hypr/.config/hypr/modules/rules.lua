-- Window and layer rules. Later rules win when several match.

-- Stop accidental double-click-on-titlebar / drag-to-top-edge maximize.
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })

-- Float these by class.
for _, class in ipairs({
    "quickshell",
    "org\\.pulseaudio\\.pavucontrol",
    "xdg-desktop-portal-(gtk|kde|hyprland)",
    "org\\.kde\\.polkit-kde-authentication-agent-1",
    "CachyOSHello",
    "zenity",
}) do
    hl.window_rule({ match = { class = "^(" .. class .. ")$" }, float = true })
end

-- Classless dialogs (file pickers, Steam updater).
for _, title in ipairs({ "Save File", "Open File", "Steam - Self Updater" }) do
    hl.window_rule({ match = { class = "^$", title = "^(" .. title .. ")$" }, float = true })
end

-- Small centred TUIs launched from keybinds (see modules/programs.lua).
for class, size in pairs({ llm = { 800, 600 }, bluetuith = { 720, 460 } }) do
    hl.window_rule({
        match        = { class = "^(" .. class .. ")$" },
        float        = true,
        size         = size,
        center       = true,
        stay_focused = true,
    })
end

-- Media viewers and floating terminals (`alacritty --class termfloat`).
hl.window_rule({
    match  = { class = "^(mpv|termfloat)$" },
    float  = true,
    size   = { 960, 540 },
    center = true,
})

-- Picture-in-picture: floating, on every workspace, bottom-right corner.
hl.window_rule({
    match = { title = "^(Picture[- ]in[- ][Pp]icture)" },
    float = true,
    pin   = true,
    size  = { 960, 540 },
    move  = { "monitor_w-window_w-20", "monitor_h-window_h-20" },
})

-- rofi is a regular window under Wayland; make it look like an overlay.
hl.window_rule({
    match       = { title = "^(rofi)" },
    float       = true,
    border_size = 0,
    no_shadow   = true,
    no_blur     = true,
})

hl.window_rule({ match = { class = "^(discord)$" },                         opacity = "0.96" })
hl.window_rule({ match = { class = "^(firefox|org\\.mozilla\\.firefox)$" }, no_blur = true })

hl.layer_rule({ match = { namespace = "^hyprpaper$" }, animation = "fade 50%" })
