{pkgs, ...}: let
  swww-timer = pkgs.writeShellScriptBin "swww-timer" ''
    while true; do
        swww-random
        sleep 900
    done
  '';
in {
  home.packages = [swww-timer];
}
