{ config
, pkgs
, lib
, ...
}:
let
  inherit (config) custom;
  inherit (lib) mkIf;

  prg = custom.usrEnv.programs;
in
{
  config = mkIf prg.gaming.wine.enable {
    # determine which version of wine to be used
    # then add it to systemPackages
    environment.systemPackages = with pkgs; let
      winePackage = wineWow64Packages.waylandFull;
    in
    [
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
