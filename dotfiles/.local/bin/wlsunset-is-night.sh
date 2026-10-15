#!/bin/bash
# Exit 0 — сейчас ночь, exit 1 — сейчас день.
DIR="$(dirname "$(readlink -f "$0")")"
source "$DIR/wlsunset-config.sh"

to_sec() {
    # "HH:MM:SS" -> секунды от начала суток
    local h m s
    IFS=: read -r h m s <<<"$1"
    echo $((10#$h * 3600 + 10#$m * 60 + 10#$s))
}

now_s=$(to_sec "$(TZ="$TZ_NAME" date +%H:%M:%S)")
start_s=$(to_sec "$NIGHT_START")
end_s=$(to_sec "$NIGHT_END")

if [ "$start_s" -lt "$end_s" ]; then
    # обычный интервал внутри суток
    [ "$now_s" -ge "$start_s" ] && [ "$now_s" -lt "$end_s" ] && exit 0 || exit 1
else
    # интервал пересекает полночь
    [ "$now_s" -ge "$start_s" ] || [ "$now_s" -lt "$end_s" ] && exit 0 || exit 1
fi
