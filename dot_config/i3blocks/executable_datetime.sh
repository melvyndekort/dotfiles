#!/bin/sh

case $BLOCK_BUTTON in
  1) notify-send -t 0 "Date" "$(cal)" ;;
  2) notify-send "Datetime module" "\- Left click to show the calendar of this month
- Right click to show the calendar for this year" ;;
  3) notify-send -t 0 "Date" "$(cal -y)" ;;
esac

echo "<span size='16pt'></span> <span rise='2pt'>$(date '+%Y-%m-%d %H:%M:%S')</span>"
