#!/bin/sh

printf "\n\n"

dunstctl is-paused | grep -q '^true$'
if [ "$?" -eq 0 ]; then
  echo "#FFB86C"
fi
