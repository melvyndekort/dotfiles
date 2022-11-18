#!/bin/sh

printline() {
  echo "<span size='14pt'>$1</span> <span rise='2pt'>$2%</span>"
  echo "<span size='14pt'>$1</span> <span rise='2pt'>$2%</span>"
}

case $BLOCK_BUTTON in
  1) notify-send "ACPI information" "$(acpi -V)" ;;
	2) notify-send "ACPI module" "\- Shows battery status.
- Click to show all ACPI info." ;;
esac

INSTANCE="BAT${BLOCK_INSTANCE:-0}"

# exit when the system doesn't have a battery
if [ ! -d "/sys/class/power_supply/${INSTANCE}" ]; then
  echo "<span size='14pt'></span>"
  echo "<span size='14pt'></span>"
  exit 0
fi

STATUS="$(cat /sys/class/power_supply/${INSTANCE}/status)"
CAPACITY="$(cat /sys/class/power_supply/${INSTANCE}/capacity)"

if [ "$STATUS" = "Charging" ]; then
  if [ "$CAPACITY" -le "10" ]; then
    printline "" "$CAPACITY"
  elif [ "$CAPACITY" -le "20" ]; then
    printline "" "$CAPACITY"
  elif [ "$CAPACITY" -le "30" ]; then
    printline "" "$CAPACITY"
  elif [ "$CAPACITY" -le "40" ]; then
    printline "" "$CAPACITY"
  elif [ "$CAPACITY" -le "50" ]; then
    printline "" "$CAPACITY"
  elif [ "$CAPACITY" -le "60" ]; then
    printline "" "$CAPACITY"
  elif [ "$CAPACITY" -le "70" ]; then
    printline "" "$CAPACITY"
  elif [ "$CAPACITY" -le "80" ]; then
    printline "" "$CAPACITY"
  elif [ "$CAPACITY" -le "90" ]; then
    printline "" "$CAPACITY"
  else
    printline "" "$CAPACITY"
  fi
else
  if [ "$CAPACITY" -le "10" ]; then
    printline "" "$CAPACITY"
    exit 33
  elif [ "$CAPACITY" -le "20" ]; then
    printline "" "$CAPACITY"
    echo "#ff5555"
  elif [ "$CAPACITY" -le "30" ]; then
    printline "" "$CAPACITY"
    echo "#ffb86c"
  elif [ "$CAPACITY" -le "40" ]; then
    printline "" "$CAPACITY"
    echo "#f1fa8c"
  elif [ "$CAPACITY" -le "50" ]; then
    printline "" "$CAPACITY"
  elif [ "$CAPACITY" -le "60" ]; then
    printline "" "$CAPACITY"
  elif [ "$CAPACITY" -le "70" ]; then
    printline "" "$CAPACITY"
  elif [ "$CAPACITY" -le "80" ]; then
    printline "" "$CAPACITY"
  elif [ "$CAPACITY" -le "90" ]; then
    printline "" "$CAPACITY"
  else
    printline "" " $CAPACITY"
  fi
fi
