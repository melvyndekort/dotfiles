#!/bin/sh

case $BLOCK_BUTTON in
  1) notify-send "ACPI information" "$(acpi -V)" ;;
	2) notify-send "ACPI module" "\- Shows battery status.
- Click to show all ACPI info." ;;
esac

INSTANCE="${BLOCK_INSTANCE:-0}"

# exit when the system doesn't have a battery
if [ ! -d "/sys/class/power_supply/BAT${INSTANCE}" ]; then
  echo "<span font_family=\"Noto Color Emoji\" size=\"medium\">⚡</span>"
  #echo "ﮣ"
  exit 0
fi

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
    print "<span font_family=\"Noto Color Emoji\" size=\"medium\">⚡</span>" $0
  } else if ($1 <= 7) {
    print "<span font_family=\"Noto Color Emoji\" size=\"medium\">🔋</span>" $0
    exit 33
  } else if ($1 <= 20) {
    print "<span font_family=\"Noto Color Emoji\" size=\"medium\">🔋</span>" $0
    print "<span font_family=\"Noto Color Emoji\" size=\"medium\">🔋</span>" $0
    print "#FF5555"
  } else if ($1 <= 55) {
    print "<span font_family=\"Noto Color Emoji\" size=\"medium\">🔋</span>" $0
    print "<span font_family=\"Noto Color Emoji\" size=\"medium\">🔋</span>" $0
    print "#FFB86C"
  } else if ($1 <= 70) {
    print "<span font_family=\"Noto Color Emoji\" size=\"medium\">🔋</span>" $0
    print "<span font_family=\"Noto Color Emoji\" size=\"medium\">🔋</span>" $0
    print "#F1FA8C"
  } else {
    print "<span font_family=\"Noto Color Emoji\" size=\"medium\">🔋</span>" $0
    print "<span font_family=\"Noto Color Emoji\" size=\"medium\">🔋</span>" $0
    print "#50FA7B"
  }
}'
