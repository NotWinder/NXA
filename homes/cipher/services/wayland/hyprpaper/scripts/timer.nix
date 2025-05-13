{pkgs, ...}: let
  hyprpaper-timer = pkgs.writeShellScriptBin "hyprpaper-timer" ''
    while true; do
        sleep 1
        hyprpaper-random
        sleep 900
    done
  '';
in {
  home.packages = [hyprpaper-timer];
}
