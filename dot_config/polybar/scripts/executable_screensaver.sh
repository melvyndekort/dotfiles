#!/bin/sh

# Get screensaver timeout
timeout=$(xset q | awk '/timeout:/ {print $2}')

if [ "$timeout" -eq 0 ]; then
    # Screensaver disabled → unlock icon
    echo "%{F#FFB86C}%{F-}"
    exit 1
else
    # Screensaver enabled → lock icon
    echo "%{F#6272A4}%{F-}"
    exit 0
fi