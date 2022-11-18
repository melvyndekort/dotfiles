#!/bin/sh

case $BLOCK_BUTTON in
  1) dunstctl set-paused toggle;;
  2) notify-send " Notification module" "\- Click to pause/unpause" ;;
esac

if dunstctl is-paused | grep -q true; then
  echo "<span size='20pt' color='#FFB86C'></span>"
else
  echo "<span size='20pt'></span>"
fi

