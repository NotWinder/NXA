{ pkgs, inputs, ... }:

{
  ## Install Packages
  environment.systemPackages = with pkgs; [
    anydesk
    doctl
    gh
    gparted
    heroic
    networkmanagerapplet
    ntfs3g
    qpwgraph
    sshuttle
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
    universal-android-debloater
    wget
  ];
}
