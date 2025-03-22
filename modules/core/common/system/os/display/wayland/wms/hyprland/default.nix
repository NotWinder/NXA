{
  inputs',
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  sys = config.modules.system;
  env = config.modules.usrEnv;

  hyprlandPkg = env.desktops.hyprland.package;
in {
  config = mkIf (sys.video.enable && (env.desktop == "Hyprland" && config.meta.isWayland)) {
    services.displayManager.sessionPackages = [hyprlandPkg];
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
