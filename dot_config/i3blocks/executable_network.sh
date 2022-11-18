#!/bin/sh

case $BLOCK_BUTTON in
  1) notify-send "IP addresses" "$(ip address show)" ;;
	2) notify-send "Network module" "\- Shows the active IP address
- Click to show the active network routes." ;;
  3) notify-send "Network routes" "$(ip route list)" ;;
esac

IPADDR=$(ip route get 1.1.1.1 | awk '{ for (nn=1;nn<=NF;nn++) if ($nn~"src") print $(nn+1) }')

if [ -z "$IPADDR" ]; then
  echo "<span size='20pt'>睊</span> <span rise='4pt'>DISCONNECTED</span>"
  exit 33
else
  echo "<span size='20pt'>直</span> <span rise='4pt'>$IPADDR</span>"
fi
