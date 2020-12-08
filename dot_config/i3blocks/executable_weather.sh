#!/bin/sh

case $BLOCK_BUTTON in
  1) mpv --no-osd-bar --x11-name=buienradar --loop-file=inf 'https://api.buienradar.nl/image/1.0/RadarMapNL?w=500&h=512' >/dev/null 2>&1 & ;;
  2) notify-send "Weather module" "\- left click to show the rain radar
- right click to show the weather forecast" ;;
  3) i3-msg -q exec "$TERMINAL -t myforecast -e zsh -c 'curl -sL wttr.in | less'" ;;
esac

FEED=$(curl -sL "https://data.buienradar.nl/2.0/feed/json" | jq -cr '.actual.stationmeasurements[] | select(.stationid==6340)')
echo $FEED | jq -cr '[.temperature, .weatherdescription] | @csv' | tr -d '"' | awk -F',' '{ printf("%sC / %s\n", $1, $2); }'
