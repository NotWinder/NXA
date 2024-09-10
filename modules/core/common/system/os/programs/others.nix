{ pkgs, ... }:

{
  ## Install Packages
  environment.systemPackages = with pkgs; [
    anydesk
    bottles
    celluloid
    doctl
    gcc
    gh
    gparted
    heroic
    mangohud
    mpv
    networkmanagerapplet
    ntfs3g
    nwg-look
    pcsx2
    picard
    picard-tools
    qpwgraph
    sing-box
    sshuttle
    telegram-desktop
    tldr
    trash-cli
    tree
    uget
    uget-integrator
    universal-android-debloater
    unrar
    unzip
    ventoy
    vlc
    wget
  ];
}
