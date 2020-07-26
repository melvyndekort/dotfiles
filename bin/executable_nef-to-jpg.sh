#!/bin/sh

set -e

DELORIG=0
while getopts 'dh' OPTION; do
  case "$OPTION" in
    d)
      DELORIG=1
      ;;

    h)
      echo "script usage: $(basename $0) [-d] [-h]" >&2
      exit 0
      ;;

    ?)
      echo "script usage: $(basename $0) [-d] [-h]" >&2
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

for SOURCE in $*; do
  [ ! -f "$SOURCE" ] && echo "$SOURCE does not exist" && continue
  [ "${SOURCE##*.}" != "NEF" ] && echo "$SOURCE is not a RAW file" && continue

  echo "Processing $SOURCE"
  TARGET="${SOURCE%.*}.jpg"
  dcraw -c -w $SOURCE | pnmtojpeg > $TARGET
  exiv2 -q -ea- $SOURCE | exiv2 -ia- $TARGET
  exiv2 -T rename $TARGET
  [ -f $TARGET ] && [ "$DELORIG" -eq "1" ] && rm -f $SOURCE
  exiv2 rename $TARGET
done
