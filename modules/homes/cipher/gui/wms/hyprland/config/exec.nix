{
  config,
  lib,
  ...
}: let
  inherit (config) modules;
  inherit (lib) mkIf;

  # theming
  inherit (modules.style) pointerCursor;

  env = modules.usrEnv;
in {
  config.hm = mkIf (env.desktop == "Hyprland") {
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
