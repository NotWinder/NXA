{
  inputs',
  pkgs,
  osConfig,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;
  env = modules.usrEnv;

  winpaper = inputs'.winpaper.packages;
  wallpaper-random =
    if env.programs.wallpapers.swww.enable
    then
      pkgs.writeShellScriptBin "wallpaper-random" ''
        TOP_DIR=${winpaper.wallpkgs}
        WALLPAPER_DIR="$TOP_DIR/share/wallpapers/"
        CURRENT_WALL=$(hyprctl hyprpaper listloaded)

        # Get the name of the focused monitor with hyprctl
        FOCUSED_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')

        # Get a random wallpaper that is not the current one
        WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

        # Apply the selected wallpaper
        sleep 1
        hyprctl hyprpaper reload "$FOCUSED_MONITOR","$WALLPAPER"
      ''
    else "";
in {
  config = mkIf env.programs.wallpapers.swww.enable {
    home.packages = [wallpaper-random];
  };
}
