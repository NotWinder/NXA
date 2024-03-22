{ pkgs, inputs, ... }:

{
  ## Install Packages
  environment.systemPackages = with pkgs; [
    anydesk
    bat
    doctl
    fastfetch
    gh
    gparted
    heroic
    networkmanagerapplet
    ntfs3g
    obs-studio
    qpwgraph
    sshuttle
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

    chromium
  ];
}
