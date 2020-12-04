#!/bin/sh

case $BLOCK_BUTTON in
	1) notify-send "Top memory consumers" "$(ps axh -o comm:20,%mem --sort=-%mem | sed 's/$/%/' | head)" ;;
	2) notify-send "Memory module" "\- Shows memory Used/Total
- Left click to show memory hogs
- Right click to run htop" ;;
	3) $TERMINAL -e htop >/dev/null 2>&1 & ;;
esac

free -h | awk '/^Mem:/ {print $3 "/" $2}'