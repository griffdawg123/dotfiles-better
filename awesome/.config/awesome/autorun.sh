#!/bin/sh

run() {
  if ! pgrep -f "$1" ;
  then
    "$@"&
  fi
}

run picom -b
run nitrogen --set-zoom-fill ~/.config/nitrogen/backgrounds/smash_pkmn.png
run polybar --config="~/.config/polybar/config.ini"
