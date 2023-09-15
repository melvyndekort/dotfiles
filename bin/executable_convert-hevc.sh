#!/bin/sh

set -e

ssh lmserver find /var/mnt/storage/photos -name \*.mp4 ! -name \*-hevc.mp4 |
while read FILE; do
  echo "Start processing $FILE"

  echo "Downloading source file"
  scp lmserver:"$(echo $FILE | sed 's/\ /\\\ /g')" "source.mp4"

  NEWFILE="$(echo $FILE | sed 's/.mp4$/-hevc.mp4/g')"

  echo "Converting to HEVC format"
  ffmpeg -nostdin -i "source.mp4" -c:v libx265 -crf 26 -preset fast -c:a copy "target.mp4"

  echo "Uploading target file ($NEWFILE)"
  scp target.mp4 lmserver:"$(echo $NEWFILE | sed 's/\ /\\\ /g')"

  echo "Deleting original file"
  ssh lmserver rm "$FILE"
  rm -f "source.mp4" "target.mp4"

  echo "Finished processing $FILE"
  echo
done
