#!/bin/bash
export WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-wayland-1}
killall wlsunset 2>/dev/null
/usr/bin/wlsunset -l 55.75 -L 37.62 -t 2300 -T 2301 
