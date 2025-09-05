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
      gestures = {
        workspace_swipe_distance = true;
        workspace_swipe_forever = true;
      };
    };
  };
}
