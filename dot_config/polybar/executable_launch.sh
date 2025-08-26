#!/bin/sh

# Kill running polybars
killall -q polybar

# Wait until processes are gone
while pgrep -u "$UID" -x polybar >/dev/null; do sleep 1; done

PRIMARY=$(xrandr --query | grep " primary" | cut -d" " -f1)

for m in $(polybar --list-monitors | cut -d":" -f1); do
    if [ "$m" = "$PRIMARY" ]; then
        MONITOR="$m" polybar --reload main &
    else
        MONITOR="$m" polybar --reload main-no-tray &
    fi
done
