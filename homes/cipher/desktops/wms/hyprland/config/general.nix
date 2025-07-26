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
