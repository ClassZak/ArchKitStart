{ config, pkgs, ... }:

let
  # ============================================================
  # ПЕРЕКЛЮЧАТЕЛИ
  # ============================================================
  nvidia_support = false;   # true – NVIDIA, false – open source (modesetting)
  uefi_support   = false;   # true – UEFI (systemd-boot), false – Legacy BIOS (GRUB)
  mod_key        = "ALT";   # "SUPER" (Win) для физ. машины, "ALT" для виртуалки
  # ============================================================

  mod = if mod_key == "SUPER" then "SUPER" else "ALT";

  # Скрипты wlsunset (можно оставить как есть)
  wlsunset-toggle = pkgs.writeShellScriptBin "wlsunset-toggle" ''
    if systemctl --user is-active --quiet wlsunset-night; then
      systemctl --user stop wlsunset-night
      notify-send "Night mode" "Disabled" -t 1500
    else
      systemctl --user start wlsunset-night
      notify-send "Night mode" "Enabled" -t 1500
    fi
  '';

  wlsunset-on = pkgs.writeShellScriptBin "wlsunset-on" ''
    systemctl --user start wlsunset-night
    notify-send "Night mode" "Enabled" -t 1500
  '';

  wlsunset-off = pkgs.writeShellScriptBin "wlsunset-off" ''
    systemctl --user stop wlsunset-night
    notify-send "Night mode" "Disabled" -t 1500
  '';

  wlsunset-status = pkgs.writeShellScriptBin "wlsunset-status" ''
    if systemctl --user is-active --quiet wlsunset-night; then
      echo '{"text":"🌙","tooltip":"Night mode active","class":"active"}'
    else
      echo '{"text":"☀️","tooltip":"Night mode inactive","class":"inactive"}'
    fi
  '';
in
{
  imports = [ ./hardware-configuration.nix ];

  # -------------------------- Система --------------------------
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # -------------------------- Локали и клавиатура --------------------------
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  console.keyMap = "ru";

  # -------------------------- Графика и дисплей --------------------------
  # Полностью отключаем X11 и дисплей-менеджер – чистая консоль
  services.xserver.enable = false;
  services.displayManager.enable = false;

  # Устанавливаем оба WM (будут доступны, но запускаются вручную)
  programs.hyprland.enable = true;
  programs.sway.enable = true;

  # -------------------------- Звук, Bluetooth, сеть --------------------------
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  networking.networkmanager.enable = true;

  # -------------------------- Загрузчик --------------------------
  boot.loader = if uefi_support then {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  } else {
    grub.enable = true;
    grub.device = "/dev/sda";
    grub.efiSupport = false;
  };
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
      MaxAuthTries = 12;
      PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
    };
  };
  # -------------------------- Пользователь dev --------------------------
  users.users.dev = {
    isNormalUser = true;
    initialPassword = "123456";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  security.sudo.extraRules = [
    { groups = [ "wheel" ]; commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ]; }
  ];

  # -------------------------- USB-автомонтирование --------------------------
  services.udev.extraRules = ''
    SUBSYSTEM=="block", KERNEL=="sd[b-z][0-9]", ACTION=="add", ATTRS{removable}=="1", TAG+="systemd", ENV{SYSTEMD_WANTS}="usb-mount@%k.service"
  '';
  systemd.services."usb-mount@" = {
    description = "Mount USB Drive %I";
    requires = [ "dev-%i.device" ];
    after = [ "blockdev@%i.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.bash}/bin/bash -c 'mkdir -p /mnt/usb/%i && mount /dev/%i /mnt/usb/%i'";
      ExecStop = "${pkgs.bash}/bin/bash -c 'umount /mnt/usb/%i && rmdir /mnt/usb/%i || echo \"error for removing /mnt/usb/%i\"'";
    };
    wantedBy = [ "multi-user.target" ];
  };
  systemd.tmpfiles.rules = [ "d /mnt/usb 0755 root root -" ];

  # -------------------------- Пользовательские сервисы --------------------------
  systemd.user.services."wlsunset-night" = {
    description = "Night mode for wlsunset";
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.wlsunset}/bin/wlsunset -l 55.75 -L 37.62 -t 2300 -T 2301";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
  systemd.user.services."dunst" = {
    description = "Dunst notification daemon";
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.dunst}/bin/dunst";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
  systemd.user.services."cliphist" = {
    description = "Clipboard history daemon (cliphist)";
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.cliphist}/bin/cliphist server";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  # -------------------------- Отключаем logrotate (временное решение) --------------------------
  services.logrotate.enable = false;

  # -------------------------- Шрифты (глобально) --------------------------
  fonts.fontconfig.enable = true;

  # -------------------------- ENV    --------------------------
  hardware.graphics = {
    enable = true;
    # setLdLibraryPath = true; # УСТАРЕЛО, НЕ ИСПОЛЬЗУЕМ
  };
  
  environment.sessionVariables = {
    LD_LIBRARY_PATH = "${pkgs.gcc.cc.lib}/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.curl}/lib";
    LIBGL_DRIVERS_PATH = "${pkgs.mesa.drivers}/lib/dri";
  };

  # -------------------------- Пакеты --------------------------
  environment.systemPackages = with pkgs; [
    # Языки и компиляторы
    python3
    python3Packages.pip
    python3Packages.tkinter   # или python3Packages.tk
    python3Packages.pyqt5
    qt5.qtwayland 
    uv
	sudo
    ruff
    gcc gnumake cmake
    ninja meson
    nodejs yarn pnpm
    openjdk
    # Оболочки
    zsh fish tmux
    # Утилиты
    curl wget unzip ripgrep fd gdb lldb valgrind
    git vim neovim htop btop fastfetch lm_sensors
    # Wayland утилиты
    grim slurp wl-clipboard brightnessctl playerctl jq bc
    # Браузеры и редакторы
    firefox chromium
    vscode
    # Rust, Lua
    rustc cargo rust-analyzer
    lua5_4 luarocks
    # Окружение
    waybar rofi
    yazi kdePackages.dolphin foot
    dunst cliphist libnotify
    wlsunset
    wlsunset-toggle
    wlsunset-on
    wlsunset-off
    wlsunset-status
    # Шрифты
    powerline-fonts
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    dejavu_fonts
    font-awesome
    roboto
    material-design-icons
    # Для Sway
    swaylock swayidle
    fastfetch
    # Additional environment
    libGL
    libxkbcommon
    xorg.libX11
    xorg.libxcb
    mesa
    curl
    nix-prefetch-git

    # Open source not famous packages
    (pkgs.stdenv.mkDerivation {
      pname = "facad";
      version = "2.20.16";
      src = pkgs.fetchgit {
        url = "https://github.com/yellow-footed-honeyguide/facad";
        rev = "master";
        sha256 = "0ncnhl6yzhaxfdcscj09z7b28dkcsawxx297h30vlsqfrnwsq2z8";
      };
      nativeBuildInputs = [ pkgs.meson pkgs.ninja ];
    })
  ];

  system.stateVersion = "24.11";
}
