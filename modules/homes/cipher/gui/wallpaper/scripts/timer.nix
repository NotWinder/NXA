{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) elem;
  inherit (lib) mkIf;
  inherit (config) modules;
  prg = modules.usrEnv.programs;

  wallpaper-timer =
    if (!elem "none" prg.wallpapers)
    then
      pkgs.writeShellScriptBin "wallpaper-timer" ''
        while true; do
            sleep 2
            wallpaper-random
            sleep 900
        done
      ''
    else "";
in {
  config.hm = mkIf (!elem "none" prg.wallpapers) {
    home.packages = [wallpaper-timer];
  };
}
