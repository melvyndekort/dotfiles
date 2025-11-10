#!/bin/sh
xrandr $(xrandr | grep " connected" | awk '{print $1}' | grep -v "^DP-1$" | awk '{print "--output " $1 " --off"}' | tr '\n' ' ') --output DP-1 --primary --auto
