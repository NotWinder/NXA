{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
in {
  config.hm = mkIf config.custom.programs.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
      exec-once = [
        # set cursor for HL itself
        #"hyprctl setcursor ${pointerCursor.name} ${toString pointerCursor.size}"
        #"caelestia shell"
        "nm-applet"
        "systemctl --user enable --now hyprpolkitagent.service"
      ];
    };
  };
}
