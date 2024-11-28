#!/bin/sh

BASE_DIR="$HOME/Sync/pictures/wallpapers"
CACHE_FILE="$HOME/.cache/wall"

# Get the current screen resolution
RESOLUTION=$(xdpyinfo | awk '/dimensions:/ {print $2}')

WALLPAPER_DIR="$BASE_DIR/$RESOLUTION"

# Use sxiv to select a wallpaper
SELECTED_WALLPAPER=$(sxiv -rfto "$WALLPAPER_DIR" | head -n 1)

# Save the selected wallpaper to the cache file if valid
if [ -n "$SELECTED_WALLPAPER" ] && [ -f "$SELECTED_WALLPAPER" ]; then
    # Remove any existing entry for this resolution
    grep -v "^${RESOLUTION}=" "$CACHE_FILE" > "${CACHE_FILE}.tmp" 2>/dev/null
    echo "${RESOLUTION}=${SELECTED_WALLPAPER}" >> "${CACHE_FILE}.tmp"
    mv "${CACHE_FILE}.tmp" "$CACHE_FILE"
    echo "Wallpaper for resolution ${RESOLUTION} saved: $SELECTED_WALLPAPER"
else
    echo "No valid wallpaper selected."
fi
