#!/usr/bin/env bash
#
# rofi script-mode source for the games launcher (mainMod+G).
# Scans all Steam library folders for installed games and lists them.
# Invoked by rofi in two ways:
#   - with no args: print the list of entries
#   - with ROFI_INFO set (a selection was made): launch that appid
#
# Wired up via: rofi -modi "games:$this_script" -show games -theme games-zen.rasi

set -euo pipefail

# App IDs / name patterns that are Steam runtime plumbing, not games.
EXCLUDE_NAME_RE='^(Steamworks Common Redistributables|Steam Linux Runtime.*|Proton [A-Za-z0-9. ]*)$'

launch() {
    setsid steam "steam://rungameid/$1" >/dev/null 2>&1 &
    disown
}

if [ -n "${ROFI_INFO:-}" ]; then
    launch "$ROFI_INFO"
    exit 0
fi

# Collect steamapps dirs: the default one(s) plus every extra library folder
# Steam knows about (from libraryfolders.vdf), resolved and deduped.
declare -A seen
steamapps_dirs=()
for base in "$HOME/.local/share/Steam" "$HOME/.steam/steam" "$HOME/.steam/root"; do
    [ -d "$base/steamapps" ] || continue
    real=$(readlink -f "$base/steamapps")
    [ -n "${seen[$real]:-}" ] && continue
    seen[$real]=1
    steamapps_dirs+=("$real")
done

vdf="${steamapps_dirs[0]:-}/libraryfolders.vdf"
if [ -f "$vdf" ]; then
    while IFS= read -r path; do
        real=$(readlink -f "$path/steamapps" 2>/dev/null) || continue
        [ -d "$real" ] || continue
        [ -n "${seen[$real]:-}" ] && continue
        seen[$real]=1
        steamapps_dirs+=("$real")
    done < <(grep -oP '"path"\s*"\K[^"]+' "$vdf")
fi

for dir in "${steamapps_dirs[@]}"; do
    for manifest in "$dir"/appmanifest_*.acf; do
        [ -f "$manifest" ] || continue
        appid=$(grep -m1 '"appid"' "$manifest" | grep -oP '"\K[0-9]+(?="$)') || continue
        name=$(grep -m1 '"name"' "$manifest" | sed -E 's/.*"name"[[:space:]]*"([^"]*)".*/\1/')
        [ -z "$appid" ] || [ -z "$name" ] && continue
        [[ "$name" =~ $EXCLUDE_NAME_RE ]] && continue

        icon=""
        for candidate in \
            "$dir/../appcache/librarycache/${appid}/library_600x900.jpg" \
            "$dir/../appcache/librarycache/${appid}/logo.png" \
            "$dir/../appcache/librarycache/${appid}/library_header.jpg" \
            "$dir/../appcache/librarycache/${appid}_icon.jpg"; do
            if [ -f "$candidate" ]; then
                icon=$(readlink -f "$candidate")
                break
            fi
        done

        if [ -n "$icon" ]; then
            printf '%s\0info\x1f%s\x1ficon\x1f%s\n' "$name" "$appid" "$icon"
        else
            printf '%s\0info\x1f%s\n' "$name" "$appid"
        fi
    done
done | sort
