{
  inputs',
  osConfig,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  inherit (osConfig) modules;
  env = modules.usrEnv;
  hyprpaper = inputs'.hyprpaper.packages.default;
in {
  config = mkIf env.programs.wallpapers.hyprpaper.enable {
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
