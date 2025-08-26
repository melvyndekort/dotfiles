#!/bin/sh

if [ "$1" = "sink" ]; then
  pactl subscribe | grep --line-buffered "sink" | while read -r UNUSED_LINE; do polybar-msg action "#pulse_out.hook.0"; done
elif [ "$1" = "source" ]; then
  pactl subscribe | grep --line-buffered "source" | while read -r UNUSED_LINE; do polybar-msg action "#pulse_in.hook.0"; done
else
  echo "Unsupported"
  exit 1
fi
