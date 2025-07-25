#!/bin/bash

APP_PATH="/home/treefrog/.config/ags/examples/gtk4/simple-bar/app.ts"

# Get the PID of a running AGS process with this file
pid=$(pgrep -f "ags run $APP_PATH")

if [ -n "$pid" ]; then
    echo "AGS is running. Killing PID $pid"
    ags quit
else
    echo "Starting AGS..."
    ags run "$APP_PATH" &
fi
