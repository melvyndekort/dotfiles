#!/bin/sh

if setxkbmap -query | grep -q '^variant.*euro'; then
  setxkbmap -layout us -variant intl -option
else
  setxkbmap -layout us -variant euro -option compose:ralt
fi
