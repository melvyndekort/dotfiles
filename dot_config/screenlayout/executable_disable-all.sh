#!/bin/sh
xrandr --auto
xrandr $(xrandr | grep " connected" | awk '{print "--output " $1 " --off"}' | tr '\n' ' ')
