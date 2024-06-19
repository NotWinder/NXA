{ pkgs, ... }:

{
  ## Install Packages
  environment.systemPackages = with pkgs; [
    anydesk
    doctl
    gh
    gparted
    heroic
    bottles
    networkmanagerapplet
    ntfs3g
    qpwgraph
    sshuttle
    android-studio
    telegram-desktop
    sing-box
    tldr
    picard
    picard-tools
    trash-cli
    tree
    unrar
    unzip
    ventoy
    vlc
    mpv
    celluloid
    pcsx2
    universal-android-debloater
    wget
  ];
}
