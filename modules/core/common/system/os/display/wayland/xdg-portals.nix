{
  config,
  pkgs,
  inputs',
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (config) modules;

  sys = modules.system;
in {
  config = mkIf sys.video.enable {
    xdg.portal = {
      enable = true;

      extraPortals = [
        inputs'.hyprland.packages.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
      ];

      config = {
        common = {
          default = ["gtk"];
        };
      };
    };
  };
}
