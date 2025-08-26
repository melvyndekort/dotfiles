#!/bin/bash

TARGET=$1
GRAY="%{F#6272A4}"
ORANGE="%{F#FFB86C}"
RESET="%{F-}"

if [[ "$TARGET" == "sink" ]]; then
    DEVICE="@DEFAULT_SINK@"
    MUTE_STATE=$(pactl get-sink-mute "$DEVICE")
    VOL=$(pactl get-sink-volume "$DEVICE" | grep -m1 -o '[0-9]\+%' | head -n1 | tr -d '%')

    if echo "$MUTE_STATE" | grep -q "yes" || [[ "$VOL" -eq 0 ]]; then
        ICON=""
        OUT="${GRAY}${ICON} ---${RESET}"
    else
        ICON=""
        OUT="${ICON} ${VOL}%"
    fi

elif [[ "$TARGET" == "source" ]]; then
    DEVICE="@DEFAULT_SOURCE@"
    MUTE_STATE=$(pactl get-source-mute "$DEVICE")
    VOL=$(pactl get-source-volume "$DEVICE" | grep -m1 -o '[0-9]\+%' | head -n1 | tr -d '%')

    if echo "$MUTE_STATE" | grep -q "yes" || [[ "$VOL" -eq 0 ]]; then
        ICON=""
        OUT="${GRAY}${ICON} ---${RESET}"
    else
        ICON=""
        OUT="${ORANGE}${ICON} ${VOL}%${RESET}"
    fi

else
    echo "Usage: $0 sink|source"
    exit 1
fi

echo "$OUT"
