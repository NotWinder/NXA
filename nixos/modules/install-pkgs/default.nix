{ pkgs, inputs, ... }:

{
  ## Install Packages
  environment.systemPackages = with pkgs; [
    appimage-run
    arandr
    bat
    chromium
    cmake
    doctl
    fastfetch
    gh
    gnumake
    gparted
    heroic
    htop
    jellyfin
    jellyfin-ffmpeg
    jellyfin-web
    jq
    networkmanagerapplet
    ntfs3g
    obs-studio
    pavucontrol
    pulseaudioFull
    qpwgraph
    rofi
    sing-box
    sshuttle
    starship
    swww
    telegram-desktop
    tldr
    trash-cli
    tree
    unrar
    unzip
    ventoy-full
    vim
    vlc
    wget
    wireplumber
    wl-clipboard
    zfs
    zoxide
  ];
}
