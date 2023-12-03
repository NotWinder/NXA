{ config, pkgs, ... }:

{
    nixpkgs.config.allowUnfree = true;
  imports =
    [
      ./hardware-configuration.nix
    ];

##  Bootloader
    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
# boot.loader.grub.efiSupport = true;
# boot.loader.grub.efiInstallAsRemovable = true;
# boot.loader.efi.efiSysMountPoint = "/boot/efi";

##  Networking
    networking.hostName = "nixos";
   #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    networking.firewall.checkReversePath = false;

##  Set your time zone.
    time.timeZone = "Asia/Tehran";

## proxy
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

##  Services {

## Picom
  services.picom.enable = true;

## Enable the OpenSSH daemon.
  services.openssh.enable = true;

## Enable the X11 windowing system.
  services.xserver.enable = true;

## Enable WindowManager
  services.xserver.windowManager.dwm.enable = true;
  programs.hyprland.enable = true;
    # overlay
  nixpkgs.overlays = [
      (final: prev: {
       dwm = prev.dwm.overrideAttrs(old: { src = /home/winder/Github/dwm-winder;});
       hyprland = prev.hyprland.overrideAttrs({ legacyRenderer = true; });
       })
  ];

## Enable DisplayManager & AutoLogin
  services.xserver.displayManager = {
	lightdm.enable = true;
  	autoLogin = {
		enable = true;
		user = "winder";
	};
  };

  services.resolved.enable = true;

  
## Enable GVFS 
  services.gvfs.enable = true;

## Configure keymap in X11
  services.xserver.layout = "us,ir";
  services.xserver.xkbOptions = "grp:alt_shift_toggle";

# Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

## Enable CUPS to print documents.
  # services.printing.enable = true;

## }

## Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.winder = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  environment.systemPackages = with pkgs; [
    appimage-run
    alacritty
    anydesk
    arandr
    autojump
    bat
    clang-tools_9
    cmake
    dmenu
    dwm
    fastfetch
    feh
    google-chrome
    gparted
    gnumake
    glibc
    gcc
    git
    gh
    htop
    kdeconnect
    libsForQt5.qt5.qtx11extras
    libsForQt5.qt5.qtx11extras.dev
    libsForQt5.qt5.qttools
    libsForQt5.qt5.qttools.dev
    libsForQt5.qt5.qtbase
    libsForQt5.qt5.qtbase.dev
    libsForQt5.qt5.qtsvg
    libsForQt5.qt5.qtsvg.dev
    libyaml
    libpng
    lxappearance
    networkmanagerapplet
    neovim
    ntfs3g
    ninja
    openjdk17-bootstrap
    protobuf
    python3
    rofi
    st
    sshuttle
    starship
    telegram-desktop
    trash-cli
    tldr
    tree
    unzip
    ventoy-full
    vlc
    vim
    wget
    xfce.thunar
    xorg.libXinerama
    xorg.libX11.dev
    xorg.libX11
    xorg.libxcb
    xorg.libXft
    xorg.xinit
    xclip
    yaml-cpp
    zxing-cpp
    zlib
  ];


## Programs

# Bash settings
  programs.bash.shellInit = "source /home/winder/.config/bash/bashrc";
  programs.bash.interactiveShellInit = "source /home/winder/.config/bash/bashrc";
# Thunar settings
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
      thunar-volman
  ];

# Fonts Config

fonts = {
    fonts = with pkgs; [
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

## Firewall Settings

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

