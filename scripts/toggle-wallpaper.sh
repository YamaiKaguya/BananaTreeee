#!/bin/bash

# ======================
# CONFIGURATION
# ======================

WALL_DIR="$HOME/Downloads"
MONITOR="eDP-1"
CURRENT_WALL_FILE="/tmp/current_wallpaper"
CONFIG_FILE="$HOME/.config/hypr/hyprpaper.conf"
AGS_THEME="$HOME/.config/scripts/ags-theme.sh"
AGS="$HOME/.config/ags/examples/gtk4/simple-bar/app.ts"
BORDER="$HOME/.config/scripts/border.sh"

# ======================
# GET CURRENT WALLPAPER
# ======================

CURRENT_WALL=$(cat "$CURRENT_WALL_FILE" 2>/dev/null)

# ======================
# PICK NEW WALLPAPER
# ======================

NEW_WALL=$(find "$WALL_DIR" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.jpeg' \) ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

# If no new wallpaper found, fallback to any image
if [[ -z "$NEW_WALL" ]]; then
  NEW_WALL=$(find "$WALL_DIR" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.jpeg' \) | shuf -n 1)
fi

# Still nothing? Exit
if [[ -z "$NEW_WALL" ]]; then
  echo "No wallpaper found in $WALL_DIR."
  exit 1
fi

# ======================
# APPLY WALLPAPER
# ======================

hyprctl hyprpaper unload all
hyprctl hyprpaper preload "$NEW_WALL"
hyprctl hyprpaper wallpaper "$MONITOR,$NEW_WALL"

# ======================
# UPDATE HYPERPAPER CONFIG
# ======================

cat >"$CONFIG_FILE" <<EOF
preload = $NEW_WALL
wallpaper = $MONITOR,$NEW_WALL
EOF

# ======================
# APPLY PYWAL + BROWSER THEME
# ======================

wal -i "$NEW_WALL"
pywalfox update

# ======================
# RELOAD AGS + BORDER
# ======================

bash "$AGS_THEME"
ags quit && ags run "$AGS"

pkill -f border.sh 2>/dev/null
bash "$BORDER"

# ======================
# SAVE CURRENT WALLPAPER
# ======================

echo "$NEW_WALL" >"$CURRENT_WALL_FILE"
