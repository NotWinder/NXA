{
  inputs,
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  inherit (osConfig) modules;
  env = modules.usrEnv;
  sys = modules.system;

  winpaper = inputs.winpaper.packages.${pkgs.stdenv.system};
  hyprpaper = inputs.hyprpaper.packages.${pkgs.stdenv.system}.default;

  Jinx = "${winpaper.shows}/share/wallpapers/shows/Jinx.jpg";
  #Bill = "${winderpaper.shows}/share/wallpapers/shows/Bill.png";
  #Victor = "${winderpaper.shows}/share/wallpapers/shows/Victor.jpg";
in {
  config = mkIf ((sys.video.enable) && (osConfig.meta.isWayland && (env.desktop == "Hyprland"))) {
    services.hyprpaper = {
      enable = true;
      package = hyprpaper;
      settings = {
        ipc = "on";
        splash = false;
        preload = [
          "${Jinx}"
          #"${Bill}"
          #"${Victor}"
        ];
        wallpaper = [
          ",${Jinx}"
          #",${Bill}"
        ];
      };
    };
  };
}
