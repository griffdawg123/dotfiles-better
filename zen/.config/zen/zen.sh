#!/bin/sh
# Zen palette — canonical shell colour exports
# Single source of truth for hex values across the whole desktop.
#
# Hyprland mirror : ~/.config/hypr/colors.conf  (rgba format)
# Quickshell mirror: ~/.config/quickshell/Theme.qml  (manually kept in sync)
# Alacritty import : ~/.config/alacritty/zen-colors.toml
# tmux             : uses 256-colour indices that map to these values
#
# Usage in scripts: . ~/.config/zen/zen.sh

# ── Backgrounds ───────────────────────────────────────────────────────────────
export ZEN_BG="#1c1c1c"        # colour234  near-black
export ZEN_SURFACE="#303030"   # colour236  surface
export ZEN_OVERLAY="#3a3a3a"   # colour237  overlay
export ZEN_SEPARATOR="#444444" # colour238  separator

# ── Text ──────────────────────────────────────────────────────────────────────
export ZEN_MUTED="#878787"     # colour102  dim gray
export ZEN_FG="#87afaf"        # colour109  slate-teal (default foreground)

# ── Accents ───────────────────────────────────────────────────────────────────
export ZEN_ACCENT1="#87afaf"   # colour109  slate-teal  (primary)
export ZEN_ACCENT2="#87d7af"   # colour115  seafoam     (secondary)
export ZEN_GREEN="#87af87"     # colour108  sage
export ZEN_YELLOW="#d7af5f"    # colour179  amber
export ZEN_RED="#d78787"       # colour174  dusty rose
