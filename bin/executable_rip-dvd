#!/bin/sh

if [ $# -ne 1 ]; then
  echo "This script needs exactly 1 argument: the name of the iso to generate"
  exit 1
fi

BLOCKSIZE=$(isoinfo -d -i /dev/sr0 | grep -i 'block size' | tr -d ' ' | cut -d':' -f2)
COUNT=$(isoinfo -d -i /dev/sr0 | grep -i 'volume size' | tr -d ' ' | cut -d':' -f2)

dd if=/dev/sr0 of=$1 bs=$BLOCKSIZE count=$COUNT

