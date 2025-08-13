{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;
  env = modules.usrEnv;

  wallpaper-timer = pkgs.writeShellScriptBin "wallpaper-timer" ''
    while true; do
        sleep 2
        wallpaper-random
        sleep 900
    done
  '';
in {
  config = mkIf env.programs.wallpapers.enable {
    home.packages = [wallpaper-timer];
  };
}
