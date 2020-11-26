#!/bin/sh

case $BLOCK_BUTTON in
  1) notify-send "Storage usage" "$(df -hTlP -x tmpfs -x devtmpfs --total)" ;;
  2) notify-send "Filesystem module " "\- Shows used space in /home filesystem.
- Click to see the filesystem listings of all filesystems.
- Right click to see all block devices" ;;
  3) notify-send "Block devices" "$(lsblk -o NAME,TYPE,FSTYPE,LABEL,FSSIZE,FSUSED,FSAVAIL,FSUSE%,MOUNTPOINT)" ;;
esac

df -BG /home | sed -n 2p | tr -d 'G%' | awk '{
  print $3"G/"$2"G";
  print $3"G/"$2"G";
  if ($5 >= "95") {
    exit 33;
  }
  else if ($5 >= "80") {
    print "#FFB86C";
  }
}'
