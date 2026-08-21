#!/usr/bin/env bash
set -u

MESSAGE_SUMMARY="$1"
MESSAGE_BODY="$2"

# Get a list of UIDs of users with active sessions
mapfile -t USERS < <(loginctl list-sessions --no-legend | awk '{print $1}' | while read sid; do
	loginctl show-session "$sid" -p User --value
done | sort -u)

for UID_NUM in "${USERS[@]}"; do
	# Find the sway process for this user
	SWAY_PID=$(pgrep -u "$UID_NUM" -x sway | head -1)
	if [ -z "$SWAY_PID" ]; then
		continue
	fi

	# Extract environment variables from /proc/$SWAY_PID/environ
	# Use sed to extract the exact value after the first '='
	DBUS_SESSION_BUS_ADDRESS=$(tr '\0' '\n' < /proc/$SWAY_PID/environ | sed -n 's/^DBUS_SESSION_BUS_ADDRESS=//p')
	XDG_RUNTIME_DIR=$(tr '\0' '\n' < /proc/$SWAY_PID/environ | sed -n 's/^XDG_RUNTIME_DIR=//p')

	# Fallback values if not found
	if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
		DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${UID_NUM}/bus"
	fi
	if [ -z "$XDG_RUNTIME_DIR" ]; then
		XDG_RUNTIME_DIR="/run/user/${UID_NUM}"
	fi

	# Send the notification
	timeout 5 runuser -u "$UID_NUM" -- \
		env DBUS_SESSION_BUS_ADDRESS="$DBUS_SESSION_BUS_ADDRESS" \
			XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR" \
			notify-send "$MESSAGE_SUMMARY" "$MESSAGE_BODY"
done
