#!/bin/bash
echo "=== Network Interfaces ==="
ip -br -c addr
echo
echo "=== Default Gateway ==="
ip route | grep default
echo
echo "=== DNS Status ==="
resolvectl status
echo
echo "=== Public IP ==="
curl -s --max-time 3 http://ip-api.com/json/ | jq -r 'if .status == "success" then "IP: \(.query)\nLocation: \(.city), \(.country)\nISP: \(.isp)" else "Unable to fetch" end'
echo
echo "Press Enter to close..."
read
