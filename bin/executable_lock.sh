#!/bin/sh

# Temporary files for the screenshot and lock screen image
tmpbg='/tmp/screenlock.png'
icon="$HOME/.config/awesome/icons/lock.png"

# Take a screenshot with overwrite option
scrot -o "$tmpbg"  # Capture screenshot of the entire screen

# Get display information
screens=$(xrandr | grep " connected" | sed 's/primary//' | awk '{print $3}')
positions=""

# Collect positions for each screen
for screen in $screens; do
  resolution=$(echo "$screen" | grep -o '^[0-9]*x[0-9]*')
  offset=$(echo "$screen" | grep -o '[+][0-9]*[+][0-9]*')

  # Get display width, height, x, and y offsets
  screen_width=$(echo "$resolution" | cut -d'x' -f1)
  screen_height=$(echo "$resolution" | cut -d'x' -f2)
  offset_x=$(echo "$offset" | cut -d'+' -f2)
  offset_y=$(echo "$offset" | cut -d'+' -f3)

  # Calculate position to center the icon on this screen
  icon_width=$(identify -format '%w' "$icon")
  icon_height=$(identify -format '%h' "$icon")
  pos_x=$(expr $offset_x + \( $screen_width - $icon_width \) / 2)
  pos_y=$(expr $offset_y + \( $screen_height - $icon_height \) / 2)

  positions="$positions${pos_x},${pos_y} "
done

# Create a single ImageMagick command to blur and overlay the icon
command="convert $tmpbg -scale 5% -scale 2000% "

# Generate overlay commands for each screen position
for pos in $positions; do
  command="$command-draw 'image over $pos 0 0 \"$icon\"' "
done

# Execute the command to process the image
eval $command "$tmpbg"

# Lock the screen with the final image using specified flags
i3lock -e -c 282A36 -i "$tmpbg"

# Remove the temporary background image after locking
rm "$tmpbg"
