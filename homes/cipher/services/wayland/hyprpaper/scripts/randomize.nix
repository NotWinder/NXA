{
  inputs',
  pkgs,
  ...
}: let
  winpaper = inputs'.winpaper.packages;
  hyprpaper-random = pkgs.writeShellScriptBin "hyprpaper-random" ''
    sleep 1
    TOP_DIR=${winpaper.wallpkgs}
    WALLPAPER_DIR="$TOP_DIR/share/wallpapers/"
    CURRENT_WALL=$(hyprctl hyprpaper listloaded)

    # Get a random wallpaper that is not the current one
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

    # Apply the selected wallpaper
    hyprctl hyprpaper reload ,"$WALLPAPER"
  '';
in {
  home.packages = [hyprpaper-random];
}
