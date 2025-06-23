{
  osConfig,
  lib,
  ...
}: let
  inherit (osConfig) modules;
  inherit (lib) mkIf;

  env = modules.usrEnv;
in {
  config = mkIf env.desktops.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
      gestures = {
        workspace_swipe = true;
        workspace_swipe_forever = true;
      };
    };
  };
}
