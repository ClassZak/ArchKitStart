{ config, pkgs, ... }:

let
  # ========== ПЕРЕКЛЮЧАТЕЛИ ==========
  nvidia_support = false;   # true – NVIDIA, false – open source (но без X11 не используется)
  uefi_support = false;     # true – UEFI (systemd-boot), false – Legacy BIOS (GRUB)
  mod_key = "ALT";        # "SUPER" (Win) для физической машины, "ALT" для виртуалки
  # ===================================

  mod = if mod_key == "SUPER" then "SUPER" else mod_key;

  # Скрипты wlsunset
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

  # Конфиг Hyprland
  hyprlandConfig = pkgs.writeText "hyprland.conf" ''
    monitor=,preferred,auto,auto
    exec-once = waybar & dunst & cliphist server
    input {
        kb_layout = us,ru
        kb_options = grp:alt_shift_toggle
    }
    $terminal = foot
    $menu = rofi -show drun
    $filemanager = dolphin
    $mod = ${mod}
    bind = $mod, Return, exec, $terminal
    bind = $mod, Q, killactive,
    bind = $mod, M, exit,
    bind = $mod, E, exec, $filemanager
    bind = $mod, space, exec, $menu
    bind = $mod, F, fullscreen,
    bind = $mod, V, togglefloating,
    bind = $mod, 1, workspace, 1
    bind = $mod, 2, workspace, 2
    bind = $mod, 3, workspace, 3
    bind = $mod, 4, workspace, 4
    bind = $mod, 5, workspace, 5
    bind = $mod SHIFT, 1, movetoworkspace, 1
    bind = $mod SHIFT, 2, movetoworkspace, 2
    bind = $mod SHIFT, 3, movetoworkspace, 3
    bind = $mod SHIFT, 4, movetoworkspace, 4
    bind = $mod SHIFT, 5, movetoworkspace, 5
  '';

  # Конфиг Sway
  swayConfig = pkgs.writeText "sway-config" ''
    set $mod ${mod}
    set $term foot
    set $menu rofi -show run
    set $filemanager dolphin
    input * xkb_layout us,ru
    input * xkb_options grp:alt_shift_toggle
    exec waybar
    exec dunst
    exec cliphist server
    bindsym $mod+Return exec $term
    bindsym $mod+Shift+q kill
    bindsym $mod+d exec $menu
    bindsym $mod+e exec $filemanager
    bindsym $mod+f fullscreen toggle
    bindsym $mod+Shift+space floating toggle
    bindsym $mod+1 workspace 1
    bindsym $mod+2 workspace 2
    bindsym $mod+3 workspace 3
    bindsym $mod+4 workspace 4
    bindsym $mod+5 workspace 5
    bindsym $mod+Shift+1 move container to workspace 1
    bindsym $mod+Shift+2 move container to workspace 2
    bindsym $mod+Shift+3 move container to workspace 3
    bindsym $mod+Shift+4 move container to workspace 4
    bindsym $mod+Shift+5 move container to workspace 5
    bar {
        position top
        status_command waybar
    }
  '';
in
{
  imports = [ ./hardware-configuration.nix ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
    LC_TIME = "ru_RU.UTF-8";
  };

  console.keyMap = "ru";

  # Отключаем X11 (используем только Wayland)
  services.xserver.enable = false;

  # display manager отключается автоматически, т.к. X11 выключен
  services.displayManager.enable = false;

  # Устанавливаем оконные менеджеры
  programs.hyprland.enable = true;
  programs.sway.enable = true;

  programs.zsh.enable = true;

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

  # Загрузчик
  boot.loader = if uefi_support then {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  } else {
    grub.enable = true;
    grub.device = "/dev/sda";
    grub.efiSupport = false;
  };

  users.users.dev = {
    isNormalUser = true;
    initialPassword = "123456";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" ];
    shell = pkgs.zsh;
  };

  security.sudo.extraRules = [
    { groups = [ "wheel" ]; commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ]; }
  ];

  # USB auto-mount
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

  # User services
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

  services.logrotate.enable = false;

  environment.systemPackages = with pkgs; [
    python310 python311 python312 python313 python314
    python3Packages.pip
    uv
    gcc gnumake cmake
    nodejs yarn pnpm
    openjdk
    zsh fish
    curl wget unzip ripgrep fd gdb lldb valgrind
    git vim neovim htop btop neofetch lm_sensors
    grim slurp wl-clipboard brightnessctl playerctl jq bc
    firefox chromium
    vscode
    rustc cargo rust-analyzer
    lua5_4 luarocks
    waybar rofi
    yazi kdePackages.dolphin foot
    dunst cliphist libnotify
    wlsunset
    wlsunset-toggle
    wlsunset-on
    wlsunset-off
    wlsunset-status
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    noto-fonts noto-fonts-cjk-sans noto-fonts-emoji liberation_ttf dejavu_fonts
	font-awesome
    roboto
    material-design-icons
    swaylock swayidle
	fastfetch
  ];

  environment.etc."skel/.config/hypr/hyprland.conf".source = hyprlandConfig;
  environment.etc."skel/.config/sway/config".source = swayConfig;

  system.stateVersion = "24.11";
}
