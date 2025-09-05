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
