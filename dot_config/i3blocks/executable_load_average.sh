#!/bin/sh

case $BLOCK_BUTTON in
	1) notify-send "Top CPU consumers" "$(ps axh -o comm:30,%cpu --sort=-%cpu | sed 's/$/%/' | head)" ;;
	2) notify-send "Load module " "\- Shows the average system load
- Left click to show biggest CPU consumers
- Right click to run htop" ;;
	3) i3-msg -q exec "$TERMINAL -e htop" ;;
esac

load="$(awk '{print $1}' /proc/loadavg)"
cpus="$(nproc)"

echo "<span size='24pt'></span> <span rise='6pt'>$load</span>"

awk -v cpus=$cpus -v cpuload=$load '
BEGIN {
  if (cpus <= cpuload) {
    exit 33;
  }
}'
