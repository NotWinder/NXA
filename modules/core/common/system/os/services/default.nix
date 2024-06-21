{
  services = {
    gvfs.enable = true;
    devmon.enable = true;
    udisks2.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
    accounts-daemon.enable = true;
    blueman.enable = true;

    openssh.enable = true;

    ## Resolved
    resolved.enable = true;

    ## Flatpak
    flatpak.enable = true;
  };
}
