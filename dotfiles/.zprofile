# ~/.zprofile
# Проверяем, что мы в tty1 и графическая сессия ещё не запущена
if [[ -z $WAYLAND_DISPLAY && -z $DISPLAY ]] && [[ $(tty) == /dev/tty1 ]]; then
    echo "--------------------------"
    echo "| ВЫБЕРИТЕ СЕССИЮ |"
    echo "--------------------------"
    echo "1) Sway"
    echo "2) Hyprland"
    echo "3) Остаться в консоли"
    read -p "Ваш выбор [1-3]: " choice

    case "$choice" in
        1)
            echo "Запуск Sway..."
            export XDG_SESSION_TYPE=wayland
            exec dbus-run-session sway
            ;;
        2)
            echo "Запуск Hyprland..."
            export XDG_SESSION_TYPE=wayland
            exec dbus-run-session Hyprland
            ;;
        3)
            echo "Остаемся в консоли."
            ;;
        *)
            echo "Неверный выбор, остаемся в консоли."
            ;;
    esac
fi