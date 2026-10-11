#!/usr/bin/env bash
# Apply the wallpaper to every currently-connected monitor via hyprpaper.
# Run at Hyprland startup and re-run (by monitor-watch.sh) whenever a
# monitor is hotplugged, so this works whether it's laptop-only or
# laptop + N externals without hardcoding monitor names.

WALLPAPER="$HOME/.config/hypr/wallpapers/pexels-evgeny-tchebotarev-1058775-2187605.jpg"

# Wait for hyprpaper's IPC to be up (it may not have started yet at exec-once time).
for _ in $(seq 1 50); do
    hyprctl hyprpaper listactive >/dev/null 2>&1 && break
    sleep 0.1
done

hyprctl hyprpaper preload "$WALLPAPER" >/dev/null

hyprctl -j monitors | jq -r '.[].name' | while read -r mon; do
    hyprctl hyprpaper wallpaper "$mon,$WALLPAPER" >/dev/null
done
