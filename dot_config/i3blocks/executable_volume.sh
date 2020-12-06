#!/bin/sh

printline() {
  echo "<span font_family=\"Font Awesome 5 Free Regular\" size=\"large\">$1</span> $2%"
  echo "<span font_family=\"Font Awesome 5 Free Regular\" size=\"large\">$1</span> $2%"
}

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
  printline "婢" "$VOL"
  echo "#6272A4"
elif [ "$VOL" -ge "90" ]; then
  printline "墳" "$VOL"
  exit 33
elif [ "$VOL" -ge "80" ]; then
  printline "墳" "$VOL"
  echo "#ff5555"
elif [ "$VOL" -ge "70" ]; then
  printline "墳" "$VOL"
  echo "#ffb86c"
elif [ "$VOL" -ge "60" ]; then
  printline "墳" "$VOL"
  echo "#f1fa8c"
else
  printline "奔" "$VOL"
fi
