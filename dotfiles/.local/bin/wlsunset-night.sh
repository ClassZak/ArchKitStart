#!/bin/bash
DIR="$(dirname "$(readlink -f "$0")")"
source "$DIR/wlsunset-config.sh"
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"

# Убиваем всё старое на 100%
killall wlsunset 2>/dev/null
# Небольшая пауза, чтобы Wayland-протокол успел освободиться
sleep 0.4

exec /usr/bin/wlsunset -l "$LAT" -L "$LON" -t "$TEMP_DAY" -T "$TEMP_NIGHT"
