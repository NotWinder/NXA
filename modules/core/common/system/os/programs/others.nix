{pkgs, ...}: {
  ## Install Packages
  environment.systemPackages = with pkgs; [
    anydesk
    bottles
    celluloid
    gparted
    heroic
    nwg-displays
    ntfs3g
    pcsx2
    picard
    picard-tools
    qpwgraph
    sing-box
    telegram-desktop
    tldr
    tokei
    uget
    universal-android-debloater
    unrar
    ventoy
    vlc
  ];
}
