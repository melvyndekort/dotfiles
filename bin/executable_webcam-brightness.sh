#!/bin/sh
DEV="$1"
[ ! -e "$DEV" ] && exit 0

if [ "$2" = "reset" ]; then
	v4l2-ctl -d "$DEV" -c backlight_compensation=0 -c exposure_dynamic_framerate=0 -c brightness=0
	exit 0
fi

CUR=$(v4l2-ctl -d "$DEV" -C brightness | awk '{print $2}')
NEW=$((CUR + $2))
[ "$NEW" -gt 64 ] && NEW=64
[ "$NEW" -lt -64 ] && NEW=-64
v4l2-ctl -d "$DEV" -c brightness="$NEW"
