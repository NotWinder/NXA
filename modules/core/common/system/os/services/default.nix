{ pkgs, ... }:
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

    #resolved.enable = true;

    printing = {
      enable = true;
      drivers = with pkgs; [ gutenprint foomatic-db-nonfree postscript-lexmark ];
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
    };

    flatpak.enable = true;
  };
}
