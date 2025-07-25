#!/bin/bash

WALLDIR="$HOME/Downloads/"
OUTPUT="eDP-1"
HYPRCONF="$HOME/.config/hypr/hyprpaper.conf"
IMG=$(find "$WALLDIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) | shuf -n 1)

# Update hyprpaper config
cat > "$HYPRCONF" <<EOF
preload = $IMG
wallpaper = $OUTPUT, $IMG
EOF

# Trigger fade overlay
ags request fade

# Reload hyprpaper
echo "reload" | socat - /run/user/$(id -u)/hypr/hyprpaper.sock

