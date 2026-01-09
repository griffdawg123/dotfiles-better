#!/sbin/bash

killall quickshell
pkill quickshell
sleep 0.2

quickshell -p ~/.config/quickshell/shell.qml &
