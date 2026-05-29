{
  config,
  pkgs,
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
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-wlr
      ];

      config = {
        # For *all* desktops unless overridden
        common = {
          default = ["gnome"];
          "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
        };

        # Override specifically for Niri
        # Niri uses wlr-screencopy protocol, so wlr portal is needed for screen sharing
        niri = {
          default = ["wlr" "gtk"];
          "org.freedesktop.impl.portal.Screenshot" = ["wlr"];
          "org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
          "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
        };
      };
    };
  };
}
