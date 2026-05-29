{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
in {
  config.hm = mkIf config.custom.programs.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
      xwayland = {
        force_zero_scaling = true;
      };
      general = {
        # gaps
        gaps_in = 4;
        gaps_out = 8;

        # border thiccness
        border_size = 2;
      };
    };
  };
}
