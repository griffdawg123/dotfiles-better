#!/bin/bash

DIRECTION="$1"
FOCUS_WINDOW=$(xdotool getactivewindow)
SCREEN_SIZE=$(xdotool getdisplaygeometry)
SCREEN_WIDTH=$(echo $SCREEN_SIZE | cut -d' ' -f1)
SCREEN_HEIGHT=$(echo $SCREEN_SIZE | cut -d' ' -f2)

case "$DIRECTION" in
    left)
        xdotool windowmove $FOCUS_WINDOW 0 0
        xdotool windowsize $FOCUS_WINDOW $((SCREEN_WIDTH/2)) $SCREEN_HEIGHT
        ;;
    right)
        xdotool windowmove $FOCUS_WINDOW $((SCREEN_WIDTH/2)) 0
        xdotool windowsize $FOCUS_WINDOW $((SCREEN_WIDTH/2)) $SCREEN_HEIGHT
        ;;
    top)
        xdotool windowmove $FOCUS_WINDOW 0 0
        xdotool windowsize $FOCUS_WINDOW $SCREEN_WIDTH $((SCREEN_HEIGHT/2))
        ;;
    bottom)
        xdotool windowmove $FOCUS_WINDOW 0 $((SCREEN_HEIGHT/2))
        xdotool windowsize $FOCUS_WINDOW $SCREEN_WIDTH $((SCREEN_HEIGHT/2))
        ;;
    max)
        xdotool windowmove $FOCUS_WINDOW 0 0
        xdotool windowsize $FOCUS_WINDOW $SCREEN_WIDTH $SCREEN_HEIGHT
        ;;
    center)
        WIN_SIZE=$(xdotool getwindowsize $FOCUS_WINDOW)
        WIN_WIDTH=$(echo $WIN_SIZE | cut -d' ' -f1)
        WIN_HEIGHT=$(echo $WIN_SIZE | cut -d' ' -f2)
        xdotool windowmove $FOCUS_WINDOW $(((SCREEN_WIDTH-WIN_WIDTH)/2)) $(((SCREEN_HEIGHT-WIN_HEIGHT)/2))
        ;;
    top-left)
        xdotool windowmove $FOCUS_WINDOW 0 0
        xdotool windowsize $FOCUS_WINDOW $((SCREEN_WIDTH/2)) $((SCREEN_HEIGHT/2))
        ;;
    top-right)
        xdotool windowmove $FOCUS_WINDOW $((SCREEN_WIDTH/2)) 0
        xdotool windowsize $FOCUS_WINDOW $((SCREEN_WIDTH/2)) $((SCREEN_HEIGHT/2))
        ;;
    bottom-left)
        xdotool windowmove $FOCUS_WINDOW 0 $((SCREEN_HEIGHT/2))
        xdotool windowsize $FOCUS_WINDOW $((SCREEN_WIDTH/2)) $((SCREEN_HEIGHT/2))
        ;;
    bottom-right)
        xdotool windowmove $FOCUS_WINDOW $((SCREEN_WIDTH/2)) $((SCREEN_HEIGHT/2))
        xdotool windowsize $FOCUS_WINDOW $((SCREEN_WIDTH/2)) $((SCREEN_HEIGHT/2))
        ;;
    halftop)
        xdotool windowmove $FOCUS_WINDOW 0 0
        xdotool windowsize $FOCUS_WINDOW $SCREEN_WIDTH $(((SCREEN_HEIGHT*6)/10))
        ;;
    halfbottom)
        xdotool windowmove $FOCUS_WINDOW 0 $(((SCREEN_HEIGHT*4)/10))
        xdotool windowsize $FOCUS_WINDOW $SCREEN_WIDTH $(((SCREEN_HEIGHT*6)/10))
        ;;
    halfleft)
        xdotool windowmove $FOCUS_WINDOW 0 0
        xdotool windowsize $FOCUS_WINDOW $(((SCREEN_WIDTH*6)/10)) $SCREEN_HEIGHT
        ;;
    halfright)
        xdotool windowmove $FOCUS_WINDOW $(((SCREEN_WIDTH*4)/10)) 0
        xdotool windowsize $FOCUS_WINDOW $(((SCREEN_WIDTH*6)/10)) $SCREEN_HEIGHT
        ;;
esac
