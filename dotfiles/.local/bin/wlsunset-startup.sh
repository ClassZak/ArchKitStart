#!/bin/bash
DIR="$(dirname "$(readlink -f "$0")")"

# Поднять таймеры (на случай если ещё не запущены)
systemctl --user start wlsunset-night.timer 2>/dev/null
systemctl --user start wlsunset-day.timer   2>/dev/null

# Сейчас ночь или день?
if "$DIR/wlsunset-is-night.sh"; then
    systemctl --user start wlsunset-night.service
else
    systemctl --user start wlsunset-day.service
fi
