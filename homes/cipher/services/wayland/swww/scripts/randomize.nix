{
  inputs',
  pkgs,
  ...
}: let
  winpaper = inputs'.winpaper.packages;
  swww-random = pkgs.writeShellScriptBin "swww-random" ''
    TOP_DIR=${winpaper.wallpkgs}
    WALLPAPER_DIR="$TOP_DIR/share/wallpapers/"
    CURRENT_WALL=$(swww query)

    # Get a random wallpaper that is not the current one
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

    # Apply the selected wallpaper
    sleep 1
    swww img "$WALLPAPER"
  '';
in {
  home.packages = [swww-random];
}
