#!/bin/sh
xrandr $(xrandr | grep " connected" | awk '{print $1}' | grep -v "^eDP-1$" | awk '{print "--output " $1 " --off"}' | tr '\n' ' ') --output eDP-1 --primary --auto
