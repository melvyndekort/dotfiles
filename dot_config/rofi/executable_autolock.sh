#!/bin/sh

if [ $# -eq 0 ]; then
  cat <<-END
 autolock
 unlocked
END
  
  exit 0
fi

case "$1" in
  *autolock*)
    xset dpms 0 0 0
    xset s 120 30
    notify-send "Enabled autolock"
    ;;
  *unlocked*)
    xset dpms 0 0 0
    xset s 0 0
    notify-send "Disabled autolock"
    ;;
esac

