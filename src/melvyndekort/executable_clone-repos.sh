#!/bin/sh

for i in $(gh repo list melvyndekort --json name -q '.[].name'); do
  [ ! -d "$i" ] && echo "Cloning $i" && gh repo clone $i -- --quiet
done

