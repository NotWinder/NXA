{ config
, pkgs
, lib
, ...
}:
let
  inherit (lib.modules) mkIf;
  sys = config.custom.system;
in
{
  config = mkIf sys.video.enable {
    xdg.portal = {
      enable = true;

      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };
}
