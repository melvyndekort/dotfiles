#!/bin/sh

OIFS="$IFS"
IFS=$'\n'

for i in $(find . -type f -name \*.mkv); do
  mediainfo "$i" | grep x265 > /dev/null && echo $i
done

IFS="$OIFS"
