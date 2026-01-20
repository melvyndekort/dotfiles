#!/bin/bash
if [ "$1" = "--show" ]; then
    if command -v checkupdates &>/dev/null; then
        checkupdates 2>/dev/null
    elif command -v apt &>/dev/null; then
        apt list --upgradable 2>/dev/null
    fi
else
    if command -v checkupdates &>/dev/null; then
        checkupdates 2>/dev/null | wc -l
    elif command -v apt &>/dev/null; then
        apt list --upgradable 2>/dev/null | grep -c upgradable
    else
        echo "0"
    fi
fi
