#!/bin/sh

if dunstctl is-paused | grep -q true; then
  echo "%{F#FF5555}%{F-}"
else
  echo "%{F#50FA7B}%{F-}"
fi
