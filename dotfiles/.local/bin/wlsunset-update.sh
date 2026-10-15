#!/bin/bash
# Перегенерирует override.conf для таймеров на основе wlsunset-config.sh
DIR="$(dirname "$(readlink -f "$0")")"
source "$DIR/wlsunset-config.sh"

# Проверка формата
for t in "$NIGHT_START" "$NIGHT_END"; do
    [[ "$t" =~ ^([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$ ]] \
        || { echo "Ошибка формата времени: $t (ожидается HH:MM:SS)"; exit 1; }
done

NIGHT_DIR="$HOME/.config/systemd/user/wlsunset-night.timer.d"
DAY_DIR="$HOME/.config/systemd/user/wlsunset-day.timer.d"
mkdir -p "$NIGHT_DIR" "$DAY_DIR"

cat > "$NIGHT_DIR/override.conf" <<EOF
[Timer]
OnCalendar=
OnCalendar=*-*-* ${NIGHT_START}
Persistent=true
AccuracySec=1s
EOF

cat > "$DAY_DIR/override.conf" <<EOF
[Timer]
OnCalendar=
OnCalendar=*-*-* ${NIGHT_END}
Persistent=true
AccuracySec=1s
EOF

systemctl --user daemon-reload
systemctl --user restart wlsunset-night.timer 2>/dev/null
systemctl --user restart wlsunset-day.timer   2>/dev/null

echo "Обновлено: ночь с ${NIGHT_START}, день с ${NIGHT_END}"
