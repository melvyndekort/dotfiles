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
  echo "<span font_family=\"Noto Color Emoji\" size=\"medium\">🔇</span> $VOL%"
  echo "<span font_family=\"Noto Color Emoji\" size=\"medium\">🔇</span> $VOL%"
  echo "#6272A4"
elif [ "$VOL" -gt "75" ]; then
  echo "<span font_family=\"Noto Color Emoji\" size=\"medium\">🔊</span> $VOL%"
  exit 33
elif [ "$VOL" -gt "50" ]; then
  echo "<span font_family=\"Noto Color Emoji\" size=\"medium\">🔊</span> $VOL%"
elif [ "$VOL" -lt "25" ]; then
  echo "<span font_family=\"Noto Color Emoji\" size=\"medium\">🔈</span> $VOL%"
else
  echo "<span font_family=\"Noto Color Emoji\" size=\"medium\">🔉</span> $VOL%"
fi
