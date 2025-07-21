{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;
  env = modules.usrEnv;

  wallpaper-timer = pkgs.writeShellScriptBin "wallpaper-timer" ''
    while true; do
        wallpaper-random
        sleep 900
    done
  '';
in {
  config = mkIf env.programs.wallpapers.swww.enable {
    home.packages = [wallpaper-timer];
  };
}
