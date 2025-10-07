#!/bin/sh

status=$(warp-cli --accept-tos status 2>/dev/null | grep "Status update:" | cut -d' ' -f3)

if [ "$status" = "Connected" ]; then
  warp-cli --accept-tos disconnect
else
  warp-cli --accept-tos connect
fi
