{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config) meta modules;
  inherit (lib) mkIf;

  prg = modules.usrEnv.programs;
in {
  config = mkIf prg.gui.enable {
    # determine which version of wine to be used
    # then add it to systemPackages
    environment.systemPackages = with pkgs; let
      winePackage =
        if meta.isWayland
        then wineWowPackages.waylandFull
        else wineWowPackages.stableFull;
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
