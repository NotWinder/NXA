{
  inputs',
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  env = config.modules.usrEnv;
in {
  config = mkIf (env.desktop == "Hyprland") {
    services.displayManager.sessionPackages = [inputs'.hyprland.packages.hyprland];
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
