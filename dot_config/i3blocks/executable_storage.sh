#!/bin/bash

case $BLOCK_BUTTON in
  1) notify-send "Storage usage" "$(df -hTlP -x tmpfs -x devtmpfs --total)" ;;
  2) notify-send "Filesystem module " "\- Shows used space in /home filesystem.
-- Click to see the filesystem listings of all filesystems.
-- Right click to see all block devices" ;;
  3) notify-send "Block devices" "$(lsblk -o NAME,TYPE,FSTYPE,LABEL,FSSIZE,FSUSED,FSAVAIL,FSUSE%,MOUNTPOINT)" ;;
esac

INSTANCE="${BLOCK_INSTANCE}"
URGENT_VALUE=90

if [[ "${INSTANCE}" = "" ]]; then
  INSTANCE="$HOME;free"
fi

DISPLAY=$(echo "${INSTANCE}" | awk -F ';' '{print $2}')
INSTANCE=$(echo "${INSTANCE}" | awk -F ';' '{print $1}')

if [[ "${DISPLAY}" = "" ]]; then
  DISPLAY="free"
fi

SPACE_VARS=$(df -h "${INSTANCE}" | tail -n 1 | awk '{$1="";$6="";print $0}')
PERC_SPACE=$(echo "${SPACE_VARS}" | awk -F ' ' '{print $4}' | tr -d '%')

if [[ "${DISPLAY}" = "max" ]]; then
  VALUE=$(echo "${SPACE_VARS}" | awk -F ' ' '{print $1}')
elif [[ "${DISPLAY}" = "used" ]]; then
  VALUE=$(echo "${SPACE_VARS}" | awk -F ' ' '{print $2}')
elif [[ "${DISPLAY}" = "free" ]]; then
  VALUE=$(echo "${SPACE_VARS}" | awk -F ' ' '{print $3}')
elif [[ "${DISPLAY}" = "perc" ]]; then
  VALUE="${PERC_SPACE}%"
fi

if [[ "${VALUE}" ]]; then
  echo "${VALUE}"
  echo "${VALUE}"
fi

if [[ "${PERC_SPACE}" -gt "${URGENT_VALUE}" ]]; then
  exit 33
fi

