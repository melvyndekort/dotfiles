#!/bin/sh

INSTANCE="${BLOCK_INSTANCE}"

case $BLOCK_BUTTON in
  1) amixer -q -D pulse sset $INSTANCE toggle ;;
	2) notify-send " Volume module" "\- Click to mute/unmute
- Right click to launch mixer
- Scroll to change" ;;
  3) i3-msg -q exec "$TERMINAL -t mypulsemixer -e pulsemixer" ;;
  4) amixer -q -D pulse sset $INSTANCE 5%+ ;;
  5) amixer -q -D pulse sset $INSTANCE 5%- ;;
esac

VOL="$(amixer sget $INSTANCE | grep '%' | awk -F '[][]' 'NR==1{ print $2; exit }' | tr -d '%')"
STATE="$(amixer sget $INSTANCE | grep '%' | awk -F '[][]' 'NR==1{ print $4; exit }')"

echo $VOL
echo $VOL

if [ "$STATE" = "off" -o "$VOL" -eq "0" ]; then
  echo "#6272A4"
elif [ "$INSTANCE" = "Capture" ]; then
  echo "#FFB86C"
elif [ "$VOL" -ge "90" ]; then
  exit 33
elif [ "$VOL" -ge "80" ]; then
  echo "#ff5555"
elif [ "$VOL" -ge "70" ]; then
  echo "#ffb86c"
elif [ "$VOL" -ge "60" ]; then
  echo "#f1fa8c"
fi
