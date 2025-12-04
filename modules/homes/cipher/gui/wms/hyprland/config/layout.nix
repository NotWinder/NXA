{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
in {
  config.hm = mkIf config.custom.programs.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
      dwindle = {
        pseudotile = false;
        preserve_split = "yes";
        special_scale_factor = 0.9; # restore old special workspace behaviour
      };
    };
  };
}
