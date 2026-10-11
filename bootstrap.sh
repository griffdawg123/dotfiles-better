#!/usr/bin/env bash
# Set up this machine from the dotfiles repo.
#
#   ./bootstrap.sh                    profile from hostname (ansible/vars/hosts.yml)
#   ./bootstrap.sh laptop             name the profile explicitly
#   ./bootstrap.sh -- --check --diff  dry run; args after -- go to ansible-playbook
#   ./bootstrap.sh -- -e dotfiles_backup=true   move conflicting files aside
set -euo pipefail
cd "$(dirname "$(realpath "$0")")"

profile=""
if [[ $# -gt 0 && $1 != -- ]]; then
    profile=$1
    shift
fi
[[ ${1:-} == -- ]] && shift

if ! command -v ansible-playbook >/dev/null; then
    if command -v pacman >/dev/null; then
        sudo pacman -S --needed --noconfirm ansible
    elif command -v apt-get >/dev/null; then
        sudo apt-get update && sudo apt-get install -y ansible
    else
        echo "Install ansible, then rerun." >&2
        exit 1
    fi
fi

cd ansible
args=(site.yml --ask-become-pass)
[[ -n $profile ]] && args+=(-e "profile=$profile")
exec ansible-playbook "${args[@]}" "$@"
