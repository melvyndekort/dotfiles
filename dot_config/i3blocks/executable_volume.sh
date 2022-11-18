#!/bin/sh

case $BLOCK_BUTTON in
  1) amixer -q -D pulse sset $BLOCK_INSTANCE toggle ;;
  2) notify-send " Volume module" "\- Click to mute/unmute
- Right click to launch mixer
- Scroll to change" ;;
  3) i3-msg -q exec "$TERMINAL -t mypulsemixer -e pulsemixer" ;;
  4) amixer -q -D pulse sset $BLOCK_INSTANCE 5%+ ;;
  5) amixer -q -D pulse sset $BLOCK_INSTANCE 5%- ;;
esac

case $BLOCK_INSTANCE in
  Master) GLYPH="" ;;
  Capture) GLYPH="" ;;
esac

output() {
  echo "<span ${1}><span size='17pt'>${GLYPH}</span> <span rise='3pt'>${2}%</span></span>"
}

VOL="$(amixer -c 0 -M -D pulse get $BLOCK_INSTANCE | awk '/[0-9]+%/' | awk -F '[' 'NR==1{print $(NF - 1)}' | tr -d ']' | tr -d '%')"
STATE="$(amixer -c 0 -M -D pulse get $BLOCK_INSTANCE | awk '/[0-9]+%/' | awk -F '[' 'NR==1{print $NF}' | tr -d ']')"

if [ "$STATE" = "off" -o "$VOL" -eq "0" ]; then
  output "color='#6272A4'" $VOL
elif [ "$BLOCK_INSTANCE" = "Capture" ]; then
  output "color='#FFB86C'" $VOL
elif [ "$VOL" -ge "90" ]; then
  output "" $VOL
  exit 33
elif [ "$VOL" -ge "80" ]; then
  output "color='#FF5555'" $VOL
elif [ "$VOL" -ge "60" ]; then
  output "color='#FFB86C'" $VOL
elif [ "$VOL" -ge "40" ]; then
  output "color='#F1FA8C'" $VOL
else
  output "" $VOL
fi

