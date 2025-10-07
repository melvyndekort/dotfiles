#!/bin/sh

status=$(warp-cli --accept-tos status 2>/dev/null | grep "Status update:" | cut -d' ' -f3)

if [ "$status" = "Connected" ]; then
    echo "%{F#50FA7B}%{F-}"
else
    echo "%{F#FF5555}%{F-}"
fi
