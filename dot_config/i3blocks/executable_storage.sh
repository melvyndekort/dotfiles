#!/bin/sh

case $BLOCK_BUTTON in
  1) notify-send "Storage usage" "$(df -hTlP -x tmpfs -x devtmpfs --total)" ;;
  2) notify-send "Filesystem module " "\- Shows used space in /home filesystem.
-- Click to see the filesystem listings of all filesystems.
-- Right click to see all block devices" ;;
  3) notify-send "Block devices" "$(lsblk -o NAME,TYPE,FSTYPE,LABEL,FSSIZE,FSUSED,FSAVAIL,FSUSE%,MOUNTPOINT)" ;;
esac

output() {
  case "$BLOCK_INSTANCE" in
    "/")
      GLYPH="";;
    "/home")
      GLYPH="";;
  esac
  echo "<span $1>$GLYPH $2%</span>"
}

SPACE="$(df -h "${BLOCK_INSTANCE}" | awk 'FNR==2{print $5}' | tr -d '%')"

if [ "$SPACE" -ge "95" ]; then
  output "" $SPACE
  exit 33
elif [ "$SPACE" -ge "90" ]; then
  output "color='#FF5555'" $SPACE
elif [ "$SPACE" -ge "80" ]; then
  output "color='#FFB86C'" $SPACE
elif [ "$SPACE" -ge "70" ]; then
  output "color='#F1FA8C'" $SPACE
else
  output "" $SPACE
fi
