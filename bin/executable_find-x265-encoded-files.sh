#!/bin/sh

for i in $(find . -type f -name \*.mkv); do
  CODEC=$(mediainfo --Output=JSON $i | jq -r '.media.track[] | select(."@type" == "Video") | .Encoded_Library_Name')
  [ "$CODEC" = "x265" ]; echo $i
done
