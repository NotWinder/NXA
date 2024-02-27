{ config, pkgs, ... }:

{
    nixpkgs.config.allowUnfree = true;
    imports =
        [
        /etc/nixos/hardware-configuration.nix
        ];
##  Bootloader
    boot = {
        loader = {
            grub = {
                enable = true;
                device = "nodev";
                fsIdentifier = "label";
                efiSupport = true;
            };
            efi.canTouchEfiVariables = true;
        };
        supportedFilesystems = [ "zfs" ];
        zfs.extraPools = [ "wpool" ];
        zfs.forceImportRoot = false;
    };
##  Networking
    networking = {
        hostName = "nixos";
        hostId = "cad6d24f";
        networkmanager.enable = true;
        firewall.enable = false;
    };
##  Set your time zone.
    time.timeZone = "Asia/Tehran";
## Services
    services = {
## Enable Xserver
        xserver = {
            enable = true;
            displayManager = {
                sddm = {
                    enable = true;
                    wayland.enable = true;
                    settings = {
                        Autologin = {
                            Session = "hyprland";
                            User = "winder";
                        };
                    };
                };
            };
## Configure keymap in X11
            xkb = {
                layout = "us,ir";
                options = "grp:alt_shift_toggle";
            };
## Enable Nvidia
            videoDrivers = ["nvidia"];
        };
## Enable GVFS
        gvfs.enable = true;
## Enable the OpenSSH daemon.
        openssh.enable = true;
## Enable Pipewire
        pipewire = {
            enable = true;
            audio.enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
        };
## Jellyfin
        jellyfin.enable = true;
## Sing-box
        sing-box.enable = true;
## Resolved
       resolved.enable = true;
## flacpack
       flatpak.enable = true;
    };
## Enable sound.
    sound.enable = true;

## Hardware
    hardware = {
        opengl = {
            enable = true;
            driSupport = true;
            driSupport32Bit = true;
        };
        nvidia = {
            modesetting.enable = true;
            powerManagement.enable = false;
            powerManagement.finegrained = false;
            open = false;
            nvidiaSettings = true;
            package = config.boot.kernelPackages.nvidiaPackages.stable;
        };
    };
# Define a user account.
    users.users.winder = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
    };

## Install Packages
    environment.systemPackages = with pkgs; [
            alacritty
            anydesk
            appimage-run
            arandr
            autojump
            bat
            clang-tools_9
            cmake
            doctl
            dmenu
            dwm
            fastfetch
            feh
            gcc
            gh
            git
            glibc
            gnumake
            go
            google-chrome
            gparted
            heroic
            htop
            jellyfin
            jellyfin
            jellyfin-ffmpeg
            jellyfin-web
            kdeconnect
            kitty
            libpng
            libsForQt5.qt5.qtbase
            libsForQt5.qt5.qtbase.dev
            libsForQt5.qt5.qtsvg
            libsForQt5.qt5.qtsvg.dev
            libsForQt5.qt5.qttools
            libsForQt5.qt5.qttools.dev
            libsForQt5.qt5.qtx11extras
            libsForQt5.qt5.qtx11extras.dev
            libyaml
            lxappearance
            neovim
            networkmanagerapplet
            ninja
            nodejs_21
            ntfs3g
            obs-studio
            openjdk17-bootstrap
            pavucontrol
            protobuf
            python3
            qpwgraph
            rofi
            sing-box
            sshuttle
            st
            starship
            swww
            telegram-desktop
            tldr
            trash-cli
            tree
            unzip
            ventoy-full
            vim
            vlc
            waybar
            wget
            wl-clipboard
            xorg.libX11
            xorg.libX11.dev
            xorg.libXft
            xorg.libXinerama
            xorg.libxcb
            xorg.xinit
            yaml-cpp
            zfs
            zlib
            zoxide
            zxing-cpp
            ];

## Programs
    programs = {
## Bash settings
        bash = {
            shellInit = "source /home/winder/.config/bash/bashrc";
            interactiveShellInit = "source /home/winder/.config/bash/bashrc";
        };
## Enable WindowManager
        hyprland.enable = true;
## Thunar settings
        thunar = {
            enable = true;
            plugins = with pkgs.xfce; [
                thunar-volman
            ];
        };
    };
# Fonts Config
    fonts = {
        packages = with pkgs; [
            noto-fonts
                noto-fonts-cjk
                noto-fonts-emoji
                font-awesome
                source-han-sans
                source-han-sans-japanese
                source-han-serif-japanese
                (nerdfonts.override { fonts = [ "Meslo" ]; })
        ];
        fontconfig = {
            enable = true;
            defaultFonts = {
                monospace = [ "Meslo LG M Regular Nerd Font Complete Mono" ];
                serif = [ "Noto Serif" "Source Han Serif" ];
                sansSerif = [ "Noto Sans" "Source Han Sans" ];
            };
        };
    };

## Polkit configs
    security.polkit.enable = true;
    systemd = {
        user.services.polkit-gnome-authentication-agent-1 = {
            description = "polkit-gnome-authentication-agent-1";
            wantedBy = [ "graphical-session.target" ];
            wants = [ "graphical-session.target" ];
            after = [ "graphical-session.target" ];
            serviceConfig = {
                Type = "simple";
                ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
                Restart = "on-failure";
                RestartSec = 1;
                TimeoutStopSec = 10;
            };
        };
        extraConfig = ''
            DefaultTimeoutStopSec=10s
            '';
    };
## System
    system = {
        copySystemConfiguration = true;
        stateVersion = "unstable";
    };
}
