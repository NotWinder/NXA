{
  inputs',
  osConfig,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  inherit (osConfig) modules;
  env = modules.usrEnv;
  sys = modules.system;

  hyprpaper = inputs'.hyprpaper.packages.default;
in {
  imports = [
    ./scripts
  ];

  config = mkIf ((sys.video.enable) && (osConfig.meta.isWayland && env.desktops.hyprland.enable)) {
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
