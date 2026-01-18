#!/bin/sh
set -e

# Define timers (in seconds)
LOCK_TIMEOUT=300
DPMS_TIMEOUT=600

# Get current screensaver timeout and DPMS status
timeout=$(xset q | awk '/timeout:/ {print $2}')
dpms_status=$(xset q | awk '/DPMS is/ {print $3}')

if [ "$timeout" -eq 0 ] && [ "$dpms_status" = "Disabled" ]; then
    # Currently fully disabled → enable
    xset s $LOCK_TIMEOUT 0
    xset +dpms
    xset dpms $DPMS_TIMEOUT $DPMS_TIMEOUT $DPMS_TIMEOUT
    notify-send "Screensaver enabled"
else
    # Currently enabled → disable
    xset s 0 0
    xset -dpms
    notify-send "Screensaver disabled"
fi

# Trigger Polybar hook to refresh
polybar-msg hook screensaver 1

