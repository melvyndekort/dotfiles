#!/bin/sh

# Get disk usage for real filesystems, find the highest
usage=$(df -t ext4 -t xfs -t btrfs -t ext3 -t ext2 | awk 'NR>1 {gsub(/%/, "", $5); if($5 > max) max=$5} END {print int(max)}')

# Set color based on usage threshold
if [ "$usage" -ge 90 ]; then
    color="%{F#FF5555}"  # red for error
elif [ "$usage" -ge 80 ]; then
    color="%{F#FFB86C}"  # orange for warning
else
    color="%{F#F8F8F2}"  # normal foreground
fi

echo "${color} ${usage}%%{F-}"
