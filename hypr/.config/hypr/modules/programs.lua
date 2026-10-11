-- Preferred programs, shared by keybinds and autostart.

local home = os.getenv("HOME")
local rofi = home .. "/.config/rofi"

return {
	terminal = "alacritty",
	filemanager = "dolphin",
	browser = "firefox",
	menu = rofi .. "/launchers/type-7/launcher.sh",
	power = rofi .. "/powermenu/type-2/powermenu.sh",
	games = 'rofi -modi "games:' .. rofi .. '/scripts/games.sh" -show games -theme ' .. rofi .. "/games-zen.rasi",
	emoji = "rofimoji",
	volume = "pavucontrol",
	bluetooth = "alacritty --class bluetuith -e bluetuith",
	bar = "quickshell",
	password_manager = "rofi-rbw --typer wtype",

	shot_region = "hyprshot -m region --clipboard-only",
	shot_window = "hyprshot -m window --clipboard-only",
	shot_screen = "hyprshot -m output --clipboard-only",
}
