#!/bin/bash

# Check tty session
if [[ -n $DISPLAY || -n $WAYLAND_DISPLAY ]]; then
    echo "You are in graphical session"
    exit 1
fi

if [[ $(tty) != /dev/tty* ]]; then
    echo "Start enable for tty terminal only"
    exit 1
fi

echo "Starting Hyprland ..."

# Export enviroment variables
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=hyprland
export MOZ_ENABLE_WAYLAND=1

# NVIDIA variables
# export WLR_DRM_NO_MODIFIERS=1
# export GBM_BACKEND=nvidia-drm
# export __GLX_VENDOR_LIBRARY_NAME=nvidia

# Logs directory
LOG_DIR="$HOME/.local/share/hypr"
mkdir -p "$LOG_DIR" || {
    echo "Failed to create log dir: $LOG_DIR"
    exit 1
}

# Remove logs older 7 days
find "$LOG_DIR" -name "hypr_*.log" -type f -mtime +7 -delete 2>/dev/null

LOG_FILE="$LOG_DIR/hypr_$(date +%Y.%m.%d_%H:%M:%S).log"
echo "Log will saved in: $LOG_FILE"

# Start hypr throught dbus-run-session with logging
exec dbus-run-session Hyprland 2>&1 | tee "$LOG_FILE"
