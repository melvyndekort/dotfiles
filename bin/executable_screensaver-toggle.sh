#!/bin/sh

# Get current timeout
timeout=$(xset q | awk '/timeout:/ {print $2}')

if [ "$timeout" -eq 0 ]; then
    # Currently disabled → enable
    xset s 120 30
    notify-send "Enabled screensaver"
else
    # Currently enabled → disable
    xset s 0 0
    notify-send "Disabled screensaver"
fi
