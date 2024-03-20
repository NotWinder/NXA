#!/bin/bash

# initializing the wallpaper daemon
#swww init --no-daemon &
swww query || swww init &

# Waybar
waybar &

# startup applications
/usr/lib/polkit-kde-authentication-agent-1 &
nm-applet &
blueman-applet &
wayvnc 0.0.0.0 &
