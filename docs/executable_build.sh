#!/bin/sh

rm -rf target

for i in *.md; do
  docker container run --rm -it -u 1000:1000 -v ${PWD}:/data jfroche/docker-markdown $i
done

mkdir -p target
mv *.html target/
