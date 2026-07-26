#!/bin/bash
killall wlsunset 2>/dev/null
export WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-wayland-1}
HOUR=$(TZ='Europe/Moscow' date +%H)
MIN=$(TZ='Europe/Moscow' date +%M)

# Ночной режим: с 18:00 до 5:00
if [ "$HOUR" -ge 18 ] || [ "$HOUR" -lt 5 ]; then
	/usr/bin/wlsunset -l 55.75 -L 37.62 -t 2300 -T 2301
else
	exit 0
fi


/usr/bin/wlsunset -l 55.75 -L 37.62 -t 2300 -T 2301
