{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # ---- Allow proprietary packages and set up unstable channel ----
  nixpkgs.config = {
    allowUnfree = true;
    # Make unstable packages available via pkgs.unstable
    packageOverrides = pkgs: {
      unstable = import <nixos-unstable> {
        config = config.nixpkgs.config;
      };
    };
  };

  # ---- Enable experimental Nix features (flakes and nix-command) ----
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ---- Locale settings (UTF-8 with Russian support) ----
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

  # ---- Keyboard layout (console + X11) ----
  console.keyMap = "ruwin_alt-shift-utf-8";
  services.xserver = {
    enable = true;
    layout = "us,ru";
    xkbOptions = "grp:alt_shift_toggle";
  };

  # ---- NVIDIA driver configuration ----
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
  };

  # ---- Hyprland (Wayland compositor) ----
  programs.hyprland = {
    enable = true;
    enableNvidiaPatches = true;  # Required for NVIDIA + Wayland
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # ---- Sound (PipeWire) ----
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # ---- Bluetooth ----
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # ---- Networking ----
  networking.networkmanager.enable = true;

  # ---- Bootloader (systemd-boot for UEFI) ----
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ---- User 'dev' with zsh as default shell ----
  users.users.dev = {
    isNormalUser = true;
    initialPassword = "123456";   # Change on first login
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" ];
    shell = pkgs.zsh;
  };

  # ---- Passwordless sudo for wheel group ----
  security.sudo.extraRules = [
    { groups = [ "wheel" ]; commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ]; }
  ];

  # ---- Automatic USB mounting via udev + systemd ----
  services.udev.extraRules = ''
    SUBSYSTEM=="block", KERNEL=="sd[b-z][0-9]", ACTION=="add", TAG+="systemd", ATTRS{removable}=="1", \
      ENV{SYSTEMD_WANTS}="usb-mount@%k.service"
    SUBSYSTEM=="block", KERNEL=="sd[b-z][0-9]", ACTION=="remove", \
      RUN+="/run/current-system/sw/bin/systemctl stop usb-mount@%k.service"
  '';

  systemd.services."usb-mount@" = {
    description = "Mount USB Drive %I";
    requires = [ "dev-%i.device" ];
    after = [ "blockdev@%i.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = ''
        /run/current-system/sw/bin/bash -c '\
          /run/current-system/sw/bin/mkdir -p /mnt/usb/%i && \
          /run/current-system/sw/bin/mount /dev/%i /mnt/usb/%i'
      '';
      ExecStop = ''
        /run/current-system/sw/bin/bash -c '\
          /run/current-system/sw/bin/umount /mnt/usb/%i && \
          /run/current-system/sw/bin/rmdir /mnt/usb/%i || /run/current-system/sw/bin/echo "error for removing /mnt/usb/%i"'
      '';
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemd.tmpfiles.rules = [ "d /mnt/usb 0755 root root -" ];

  # ---- Custom systemd user services for wlsunset, dunst, cliphist ----
  # wlsunset: color temperature adjustment (night mode)
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

  # dunst: notification daemon
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

  # cliphist: clipboard history manager
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

  # ---- Helper scripts for wlsunset control (toggle, on, off, status) ----
  let
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

  # ---- System packages (stable + unstable) ----
  environment.systemPackages = with pkgs; [
    # ---- Stable packages ----
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

    # ---- Unstable (latest) packages ----
    unstable.firefox
    unstable.chromium
    unstable.vscode
    unstable.rustc unstable.cargo unstable.rust-analyzer
    unstable.lua5_4 unstable.luarocks
    unstable.waybar unstable.rofi unstable.foot

    # ---- Notification daemon and clipboard manager ----
    unstable.dunst               # notification daemon
    unstable.cliphist            # clipboard history (works with wl-clipboard)
    libnotify                    # notify-send utility

    # ---- Color temperature adjustment (wlsunset) and control scripts ----
    unstable.wlsunset
    wlsunset-toggle
    wlsunset-on
    wlsunset-off
    wlsunset-status

    # ---- Fonts (Nerd Fonts + system fonts) ----
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "CascadiaCode" "Noto Sans Mono" ]; })
    noto-fonts noto-fonts-cjk-sans noto-fonts-emoji liberation_ttf dejavu_fonts
  ];

  system.stateVersion = "24.11";
}
