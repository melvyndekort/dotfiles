#!/bin/sh

case $BLOCK_INSTANCE in
  Master)
    GLYPH=""
    TYPE=sink
    NAME=@DEFAULT_SINK@
    ;;
  Capture)
    GLYPH=""
    TYPE=source
    NAME=@DEFAULT_SOURCE@
    ;;
esac

case $BLOCK_BUTTON in
  1) pactl set-$TYPE-mute $NAME toggle ;;
  2) notify-send " Volume module" "\- Click to mute/unmute
- Right click to launch mixer
- Scroll to change" ;;
  3) i3-msg -q exec "$TERMINAL -t mypulsemixer -e pulsemixer" ;;
  4) pactl set-$TYPE-volume $NAME +5% ;;
  5) pactl set-$TYPE-volume $NAME -5% ;;
esac

output() {
  echo "<span $1>$GLYPH $2%</span>"
}

VOL="$(pactl get-$TYPE-volume $NAME | grep -Po '\d+(?=%)' | head -n 1)"
STATE="$(pactl get-$TYPE-mute $NAME | cut -d' ' -f2)"

if [ "$STATE" = "yes" -o "$VOL" -eq "0" ]; then
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
