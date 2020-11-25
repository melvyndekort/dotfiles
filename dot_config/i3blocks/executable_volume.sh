#!/bin/sh

case $BLOCK_BUTTON in
  1) amixer -q -D pulse sset Master toggle ;;
	2) notify-send " Volume module" "\- Click to mute/unmute
- Right click to launch mixer
- Scroll to change" ;;
  3) $TERMINAL -t mypulsemixer -e pulsemixer >/dev/null 2>&1 & ;;
  4) amixer -q -D pulse sset Master 5%+ ;;
  5) amixer -q -D pulse sset Master 5%- ;;
esac

VOL=$(amixer -D pulse sget Master | grep 'Left:' | awk -F'[][]' '{ print $2 }' | tr -d '%')
STATE=$(amixer -D pulse sget Master | grep 'Left:' | awk -F'[][]' '{ print $4 }')


if [ "$STATE" = "off" -o "$VOL" -eq "0" ]; then
  printf " %s\n" "$VOL%" "$VOL%"
  echo "#6272A4"
elif [ "$VOL" -gt "70" ]; then
  printf " %s\n" "$VOL%" "$VOL%"
  exit 33
else
  printf " %s\n" "$VOL%" "$VOL%"
fi
