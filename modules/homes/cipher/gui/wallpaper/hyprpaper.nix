{
  inputs',
  config,
  lib,
  ...
}: let
  inherit (builtins) elem;
  inherit (lib) mkIf;

  inherit (config) modules;
  prg = modules.usrEnv.programs;
  hyprpaper = inputs'.hyprpaper.packages.default;
in {
  config.hm = mkIf (elem "hyprpaper" prg.wallpapers) {
    services.hyprpaper = {
      enable = true;
      package = hyprpaper;
      settings = {
        ipc = "on";
        splash = false;
      };
    };
  };
}
