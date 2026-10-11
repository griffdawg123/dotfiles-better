#!/usr/bin/env bash
# Listen on Hyprland's event socket and re-sync wallpapers whenever a
# monitor is plugged in, so newly-connected screens don't sit blank
# showing Hyprland's fallback background.

SOCK="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

socat -U - "UNIX-CONNECT:$SOCK" | while read -r line; do
    case "$line" in
        monitoraddedv2*|monitoradded*)
            "$SCRIPT_DIR/wallpaper-sync.sh"
            ;;
    esac
done
