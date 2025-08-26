#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Sync/pictures/wallpapers"
feh_args=()

echo "Detecting connected monitors and resolutions..."

# Collect resolutions
while read -r line; do
    res=$(echo "$line" | sed 's/+.*//')
    folder="$WALLPAPER_DIR/$res"
    if [[ -d "$folder" ]]; then
        echo "Found folder for resolution $res: $folder"
    else
        folder="$WALLPAPER_DIR/default"
        echo "No folder for $res, using default: $folder"
    fi
    feh_args+=(--bg-fill --randomize "$folder")
done < <(xrandr --query | awk '/ connected/ {
    for (i=3; i<=NF; i++) {
        if ($i ~ /^[0-9]+x[0-9]+\+/) {print $i; break}
    }
}')

echo "Applying wallpapers..."
feh "${feh_args[@]}"
echo "Done!"
