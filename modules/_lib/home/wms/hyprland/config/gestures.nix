{config, lib, osConfig, ...}:
let
  inherit (lib) mkIf;
in
{
  config = mkIf osConfig.custom.programs.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
      gestures = {
        workspace_swipe_distance = true;
        workspace_swipe_forever = true;
      };
    };
  };
}
