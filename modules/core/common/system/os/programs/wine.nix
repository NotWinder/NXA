{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config) modules;
  inherit (lib) mkIf;

  prg = modules.usrEnv.programs;
in {
  config = mkIf prg.gui.enable {
    # determine which version of wine to be used
    # then add it to systemPackages
    environment.systemPackages = with pkgs; let
      winePackage = wineWowPackages.waylandFull;
    in [
      winePackage
      gsettings-desktop-schemas
      gtk3
    ];
    services.dbus.packages = with pkgs; [
      gsettings-desktop-schemas
      gtk3
    ];
  };
}
