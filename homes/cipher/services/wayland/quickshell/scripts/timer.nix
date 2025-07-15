{pkgs, ...}: let
  wallpaper-timer = pkgs.writeShellScriptBin "wallpaper-timer" ''
    while true; do
        wallpaper-random
        sleep 900
    done
  '';
in {
  home.packages = [wallpaper-timer];
}
