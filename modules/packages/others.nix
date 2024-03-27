{ pkgs, inputs, ... }:

{
  ## Install Packages
  environment.systemPackages = with pkgs; [
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
    trash-cli
    tree
    peazip
    unrar
    unzip
    ventoy
    vlc
    wget
  ];
}
