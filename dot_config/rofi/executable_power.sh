#!/bin/sh

if [ $# -eq 0 ]; then
  cat <<-END
 lock
 logout
 suspend
鈴 hibernate
 reboot
 shutdown
END
  
  exit 0
fi

case "$1" in
  *lock*)      xset s activate ;;
  *logout*)    i3-msg exit ;;
  *suspend*)   xset s activate; systemctl suspend ;;
  *hibernate*) xset s activate; systemctl hibernate ;;
  *reboot*)    systemctl reboot ;;
  *shutdown*)  systemctl poweroff -i ;;
esac

