#!/bin/sh

case $BLOCK_BUTTON in
  1) dunstctl set-paused toggle;;
	2) notify-send " Notification module" "\- Click to pause/unpause" ;;
esac

printf "\n\n"

dunstctl is-paused | grep -q '^true$'
if [ "$?" -eq 0 ]; then
  echo "#FFB86C"
fi
