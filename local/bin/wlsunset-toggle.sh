#!/bin/bash

SERVICE="wlsunset-night.service"

case "$1" in
	toggle)
		if systemctl --user is-active --quiet "$SERVICE"; then
			systemctl --user stop "$SERVICE"
		else
			systemctl --user start "$SERVICE"
		fi
		;;
	status)
		if systemctl --user is-active --quiet "$SERVICE"; then
			echo '{"text":"🌙","tooltip":"Ночной режим включён","class":"active"}'
		else
			echo '{"text":"☀️","tooltip":"Ночной режим выключен","class":"inactive"}'
		fi
		;;
esac
