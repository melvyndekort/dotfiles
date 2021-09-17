#!/bin/sh

bluetoothctl power off
sleep 1
bluetoothctl power on
bluetoothctl agent on
bluetoothctl default-agent
sleep 1
bluetoothctl connect "88:D0:39:99:CC:BF"
bluetoothctl connect "1C:E6:1D:10:0E:3F"
sleep 3

for CARD in $(pactl list cards short | grep bluez_card | awk '{print $1}'); do
  pactl set-card-profile $CARD off
  sleep 3
  pactl set-card-profile $CARD a2dp_sink
done

pkill -RTMIN+1 i3blocks
pkill -RTMIN+2 i3blocks

notify-send 'Headphone' 'Bluetooth headphone connected'
