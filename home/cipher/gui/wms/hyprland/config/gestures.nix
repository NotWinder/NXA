{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
in {
  config.hm = mkIf config.custom.programs.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
      gestures = {
        workspace_swipe_distance = true;
        workspace_swipe_forever = true;
      };
    };
  };
}
