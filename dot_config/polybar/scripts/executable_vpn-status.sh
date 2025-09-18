#!/bin/sh

CACHE_FILE="/tmp/vpn-status-cache"

# Check if cache file was modified in the last 2 seconds (indicating VPN change)
# or if it doesn't exist
if [ ! -f "$CACHE_FILE" ] || [ "$(stat -c %Y "$CACHE_FILE" 2>/dev/null)" -gt "$(($(date +%s) - 2))" ]; then
    # Get current VPN status
    vpn="$(nmcli -t -f name,type connection show --order name --active 2>/dev/null | grep -E "vpn|wireguard" | head -1 | cut -d ':' -f 1)"
    
    if [ -n "$vpn" ]; then
        echo "VPN: $vpn" > "$CACHE_FILE"
    else
        echo "VPN: " > "$CACHE_FILE"
    fi
    
    # Reset the timestamp to avoid constant updates
    touch -d "3 seconds ago" "$CACHE_FILE"
fi

# Output cached result
cat "$CACHE_FILE"
