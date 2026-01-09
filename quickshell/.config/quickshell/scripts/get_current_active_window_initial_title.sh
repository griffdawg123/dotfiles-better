#!/usr/bin/bash
current_workspace=$(hyprctl activeworkspace -j | jq '.id')
activeWindowInitialTitle=$(hyprctl clients -j | jq '.[] | select(.workspace.id == '$current_workspace') | select(.class == '\"$1\"').initialTitle')
echo "$activeWindowInitialTitle" | head -n 1 | tr -d '"'
