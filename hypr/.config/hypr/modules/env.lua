-- Hyprland exports these to systemd/D-Bus itself, so portals and
-- D-Bus-activated apps see them without a separate import step.

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Makes Qt6/KF6 apps (Dolphin etc.) read ~/.config/kdeglobals instead of
-- Qt's light default. Needs plasma-integration + breeze.
hl.env("QT_QPA_PLATFORMTHEME", "kde")

-- Electron apps default to X11; let them pick Wayland.
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
