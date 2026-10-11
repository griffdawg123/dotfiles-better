#!/usr/bin/env bash
# Stow one package into $HOME, clearing the way first:
#   - links that already point into the dotfiles repo (e.g. made by hand
#     with ln -s, which stow doesn't recognise as its own) are replaced
#   - real files are moved to BACKUP_DIR if given, otherwise we stop
#
# Usage: stow-package.sh DOTFILES_DIR PACKAGE [BACKUP_DIR]
# Prints CHANGED when anything was modified. STOW_DRY_RUN=1 only reports.
set -euo pipefail

repo=$(realpath "$1")
pkg=$2
backup=${3:-}
dry=${STOW_DRY_RUN:-}

stow_cmd=(stow --dir="$repo" --target="$HOME" --verbose=1)

changed=0
failed=0

sim=$("${stow_cmd[@]}" --no "$pkg" 2>&1 || true)

while IFS= read -r target; do
    [[ -z $target ]] && continue
    path="$HOME/$target"

    if [[ -L $path && $(realpath -m "$path") == "$repo"/* ]]; then
        echo "relink ~/$target (already points into the repo)"
        [[ -z $dry ]] && rm "$path"
        changed=1
    elif [[ -n $backup ]]; then
        echo "backup ~/$target -> $backup/$target"
        if [[ -z $dry ]]; then
            mkdir -p "$backup/$(dirname "$target")"
            mv "$path" "$backup/$target"
        fi
        changed=1
    else
        echo "CONFLICT: ~/$target exists and isn't from the dotfiles repo" >&2
        failed=1
    fi
done < <(sed -nE \
    -e 's/.*existing target is not owned by stow: (.+)$/\1/p' \
    -e 's/.*over existing target (.+) since .*/\1/p' <<<"$sim")

if ((failed)); then
    echo "Move those aside or rerun with -e dotfiles_backup=true." >&2
    exit 2
fi

if [[ -n $dry ]]; then
    grep -q '^LINK' <<<"$sim" && changed=1
else
    out=$("${stow_cmd[@]}" "$pkg" 2>&1)
    grep -q '^LINK' <<<"$out" && changed=1
fi

((changed)) && echo CHANGED
exit 0
