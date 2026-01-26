#!/bin/bash

# Detect distro
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    DISTRO="unknown"
fi

# Get hostname
HOSTNAME=$(hostname)

# Select icon based on distro (Nerd Font glyphs)
case "$DISTRO" in
    arch)
        ICON=""  # Arch logo
        ;;
    ubuntu)
        ICON=""  # Ubuntu logo
        ;;
    debian)
        ICON=""  # Debian logo
        ;;
    fedora)
        ICON=""  # Fedora logo
        ;;
    *)
        ICON=""  # Generic Linux logo
        ;;
esac

echo "%{F#BD93F9}$ICON%{F-} %{F#50FA7B}$HOSTNAME%{F-}"
