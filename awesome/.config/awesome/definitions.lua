-- Definitions for Environment
terminal = "alacritty"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
browser = "firefox"
modkey = "Mod4" -- Mod4 == Windows Key
