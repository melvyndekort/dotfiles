#!/bin/sh

sourcefile=$1
targetfile="${1%.*}-reenc.mkv"

ffmpeg \
  -i $sourcefile \
  -map 0 \
  -c copy \
  -c:v libx264 \
  -preset slow \
  -tune film \
  -crf 12 \
  $targetfile
