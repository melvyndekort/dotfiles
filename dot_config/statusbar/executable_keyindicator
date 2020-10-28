#!/bin/sh

case $BLOCK_BUTTON in
  1) xdotool key Caps_Lock ;;
	2) notify-send "Key indicator module " "\- Shows the current state of CAPS Lock key.
- Click to show all X user preferences." ;;
  3) notify-send "X user preferences" "$(xset -q)" ;;
esac

MASK="$(xset -q | grep 'LED mask' | awk '{print $NF}')"
if [ $(( 0x$MASK & 0x1 )) -eq 1 ]; then
  printf "%s\n" " CAPS" "CAPS" "#FFB86C"
else
  printf "%s\n" " CAPS" "CAPS" "#6272A4"
fi
