#!/bin/bash

# Define output path
OUT="$HOME/.config/ags/examples/gtk4/simple-bar/colors.scss"

# Ensure directory exists
mkdir -p "$(dirname "$OUT")"

# Convert and write
jq -r '
  (.special + .colors) | to_entries[] |
  "$" + .key + ": " + (.value | @sh) + ";"
' ~/.cache/wal/colors.json | sed "s/'//g" > "$OUT"
