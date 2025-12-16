#!/bin/sh

if dunstctl is-paused | grep -q true; then
  # Notifications paused → red icon
  echo "%{F#FF5555}%{F-}"
else
  # Notifications enabled → green icon
  echo "%{F#50FA7B}%{F-}"
fi
