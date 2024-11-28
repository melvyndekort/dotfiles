#!/bin/sh

BASE_DIR="/home/melvyn/Sync/pictures/wallpapers"
CACHE_FILE="$HOME/.cache/wall"

# Check if a directory is passed as an argument; default to BASE_DIR if not
WALLPAPER_DIR="${1:-$BASE_DIR}"

# Use sxiv to select a wallpaper
SELECTED_WALLPAPER=$(sxiv -rfto "$WALLPAPER_DIR" | head -n 1)

# Save the selected wallpaper to the cache file if valid
if [ -n "$SELECTED_WALLPAPER" ] && [ -f "$SELECTED_WALLPAPER" ]; then
    echo "$SELECTED_WALLPAPER" > "$CACHE_FILE"
    echo "Wallpaper saved: $SELECTED_WALLPAPER"
else
    echo "No valid wallpaper selected."
fi

