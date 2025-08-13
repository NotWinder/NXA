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
      dwindle = {
        pseudotile = false;
        preserve_split = "yes";
        special_scale_factor = 0.9; # restore old special workspace behaviour
      };
    };
  };
}
