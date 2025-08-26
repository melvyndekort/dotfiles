#!/bin/sh

if dunstctl is-paused | grep -q true; then
  echo "%{F#FFB86C}%{F-}"
else
  echo "%{F#6272A4}%{F-}"
fi
