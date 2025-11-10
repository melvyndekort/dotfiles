#!/bin/sh
xrandr --auto
connected=$(xrandr | grep " connected" | awk '{print $1}' | sort)
primary=$(echo "$connected" | head -1)
xrandr --output "$primary" --primary --auto

for output in $connected; do
  if [ "$output" != "$primary" ]; then
    xrandr --output "$output" --auto --same-as "$primary"
  fi
done
