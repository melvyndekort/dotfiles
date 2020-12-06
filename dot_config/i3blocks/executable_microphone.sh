#!/bin/sh

printline() {
  echo "<span font_family=\"Font Awesome 5 Free Regular\" size=\"large\">$1</span> $2%"
  echo "<span font_family=\"Font Awesome 5 Free Regular\" size=\"large\">$1</span> $2%"
}

case $BLOCK_BUTTON in
  1) amixer -q -D pulse sset Capture toggle ;;
	2) notify-send " Microphone module" "\- Click to mute/unmute
- Right click to launch mixer
- Scroll to change" ;;
  3) $TERMINAL -t mypulsemixer -e pulsemixer >/dev/null 2>&1 & ;;
  4) amixer -q -D pulse sset Capture 10%+ ;;
  5) amixer -q -D pulse sset Capture 10%- ;;
esac

VOL=$(amixer -D pulse sget Capture | grep 'Left:' | awk -F'[][]' '{ print $2 }' | tr -d '%')
STATE=$(amixer -D pulse sget Capture | grep 'Left:' | awk -F'[][]' '{ print $4 }')

if [ "$STATE" = "off" -o "$VOL" -eq "0" ]; then
  printline "" "$VOL"
  echo "#6272A4"
else
  printline "" "$VOL"
  echo "#FFB86C"
fi
