#!/usr/bin/env bash

TARGET_OPACITY=0.85

# Получаем адрес активного окна
ADDRESS=$(hyprctl activewindow -j | jq -r '.address')
if [[ -z "$ADDRESS" || "$ADDRESS" == "null" ]]; then
    exit 1
fi

# Получаем текущую прозрачность
CURRENT_OPACITY=$(hyprctl clients -j | jq -r --arg addr "$ADDRESS" '.[] | select(.address == $addr) | .alpha // .opacity // 1.0')
echo "Текущая прозрачность: $CURRENT_OPACITY"

# Сравниваем и переключаем
if (( $(echo "$CURRENT_OPACITY < 1.0" | bc -l) )); then
    # Делаем окно непрозрачным (исправленный синтаксис!)
    hyprctl keyword windowrule "opacity 1.0 override address:$ADDRESS"
    echo "Окно стало непрозрачным."
else
    # Делаем окно прозрачным (исправленный синтаксис!)
    hyprctl keyword windowrule "opacity $TARGET_OPACITY override address:$ADDRESS"
    echo "Окно стало прозрачным ($TARGET_OPACITY)."
fi
