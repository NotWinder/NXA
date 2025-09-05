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
      dwindle = {
        pseudotile = false;
        preserve_split = "yes";
        special_scale_factor = 0.9; # restore old special workspace behaviour
      };
    };
  };
}
