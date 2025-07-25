#!/bin/bash

timestamp=$(date +%s)
frozen="/tmp/frozen_$timestamp.png"
output=~/Pictures/screenshot_$timestamp.png

# Take full screenshot
grim "$frozen"

# Show frozen image fullscreen in background
imv -f "$frozen" &
pid=$!
sleep 0.5  # Let imv load

# Let user select region
region=$(slurp)

# Always kill the image viewer
kill "$pid" 2>/dev/null

# If no region was selected, cancel
if [ -z "$region" ]; then
    rm "$frozen"
    notify-send -a "screenshot" "Screenshot canceled"
    exit 0
fi

# Parse region
IFS=', x' read -r x y width height <<< "$(echo $region | sed 's/[ x]/ /g')"

# Crop, save, copy
convert "$frozen" -crop "${width}x${height}+$x+$y" "$output"
cat "$output" | wl-copy

# Notify
notify-send -a "screenshot" "Screenshot saved and copied!" "Path: ~/Pictures"

# Clean up
rm "$frozen"
