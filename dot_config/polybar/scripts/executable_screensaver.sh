#!/bin/sh

# Get screensaver timeout
timeout=$(xset q | awk '/timeout:/ {print $2}')

if [ "$timeout" -eq 0 ]; then
  # Screensaver disabled → orange unlock icon
  echo "%{F#FFB86C}%{F-}"
  exit 1
else
  # Screensaver enabled → green lock icon
  echo "%{F#50FA7B}%{F-}"
  exit 0
fi
