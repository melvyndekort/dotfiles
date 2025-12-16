#!/bin/sh

status=$(warp-cli --accept-tos status 2>/dev/null | grep "Status update:" | cut -d' ' -f3)

if [ "$status" = "Connected" ]; then
    # Warp connected - green icon
    echo "%{F#50FA7B}%{F-}"
else
    # Warp disconnected - grey icon
    echo "%{F#6272A4}%{F-}"
fi
