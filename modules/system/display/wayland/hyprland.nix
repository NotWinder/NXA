{ config
, inputs'
, lib
, ...
}:
let
  inherit (lib.modules) mkIf;
in
{
  config = mkIf config.custom.programs.hyprland.enable {
    services.displayManager.sessionPackages = [ inputs'.hyprland.packages.hyprland ];
    programs.hyprland = {
      enable = true;
      # set the flake package
      package = inputs'.hyprland.packages.hyprland;
      # make sure to also set the portal package, so that they are in sync
      portalPackage = inputs'.hyprland.packages.xdg-desktop-portal-hyprland;
      withUWSM = true;
      systemd.setPath.enable = true;
    };
  };
}