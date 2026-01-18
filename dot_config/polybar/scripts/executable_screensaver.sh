#!/bin/sh

# Get X11 screensaver timeout
timeout=$(xset q | awk '/timeout:/ {print $2}')
# Get DPMS status
dpms_status=$(xset q | awk '/DPMS is/ {print $3}')

# Determine status: enabled if screensaver timeout > 0 or DPMS enabled
if [ "$timeout" -gt 0 ] || [ "$dpms_status" = "Enabled" ]; then
    # Screensaver enabled → green lock
    echo "%{F#50FA7B}%{F-}"
    exit 0
else
    # Screensaver disabled → orange unlock
    echo "%{F#FFB86C}%{F-}"
    exit 1
fi

