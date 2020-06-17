#!/bin/sh

case $BLOCK_BUTTON in
  1) notify-send "ACPI information" "$(acpi -V)" ;;
	2) notify-send "ACPI module" "\- Shows battery status.
- Click to show all ACPI info." ;;
esac

INSTANCE="${BLOCK_INSTANCE:-0}"

# exit when the system doesn't have a battery
[ ! -d "/sys/class/power_supply/BAT${INSTANCE}" ] && exit 0

ACPI="$(acpi -b | grep "Battery $INSTANCE")"

FULLTEXT="$(echo "$ACPI" | tr -d , | awk '
{
  print $4" "$3;
  if ($5) {
    print " ("substr($5,1,5)")"
  }
}')"

echo "$FULLTEXT" | awk -v stat="$(cat /sys/class/power_supply/BAT${INSTANCE}/status)" -F '%' '
{
  if (stat == "Charging" || stat == "Full") {
    print " "$0; print $0; print "#50FA7B"; exit 0
  } else if ($1 <= 7) {
    print " "$0; print $0; exit 33
  } else if ($1 <= 20) {
    print " "$0; print $0; print "#FF5555"; exit 0
  } else if ($1 <= 55) {
    print " "$0; print $0; print "#FFB86C"; exit 0
  } else if ($1 <= 70) {
    print " "$0; print $0; print "#F1Fa8C"; exit 0
  } else {
    print " "$0; print $0; print "#50FA7B"; exit 0
  }
}'
