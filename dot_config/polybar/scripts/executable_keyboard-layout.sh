#!/bin/sh

if setxkbmap -query | grep -q '^variant.*euro'; then
  echo US
else
  echo NL
fi
