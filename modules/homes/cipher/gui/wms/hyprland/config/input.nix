{
  config,
  lib,
  ...
}: let
  inherit (config) modules;
  inherit (lib) mkIf;

  env = modules.usrEnv;
in {
  config.hm = mkIf (env.desktop == "Hyprland") {
    wayland.windowManager.hyprland.settings = {
      input = {
        # self explanatory, I hope?
        follow_mouse = 1;
        # sensitivity of the mouse cursor
        sensitivity = 0.8;
        # imitate natural scroll
        touchpad.natural_scroll = "yes";
        # ez numlock enable
        numlock_by_default = true;
      };
    };
  };
}
