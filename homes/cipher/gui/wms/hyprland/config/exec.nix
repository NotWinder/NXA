{
  osConfig,
  lib,
  ...
}: let
  inherit (osConfig) modules;
  inherit (lib) mkIf;

  # theming
  inherit (modules.style) pointerCursor;

  env = modules.usrEnv;
in {
  config = mkIf env.desktops.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
      exec-once = [
        # set cursor for HL itself
        #"hyprctl setcursor ${pointerCursor.name} ${toString pointerCursor.size}"
        "caelestia shell"
        "nm-applet"
        "systemctl --user enable --now hyprpolkitagent.service"
      ];
    };
  };
}
