{
  inputs',
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;
  env = modules.usrEnv;

  winpaper = inputs'.winpaper.packages;
  wallpaper-random = pkgs.writeShellScriptBin "wallpaper-random" ''
    TOP_DIR=${winpaper.wallpkgs}
    WALLPAPER_DIR="$TOP_DIR/share/wallpapers/"
    # Capture the output of `swww query`
    OUTPUT=$(swww query)
    CURRENT_WALL=$(echo "$OUTPUT" | grep -m1 'image:' | sed 's/.*image: //')

    # Get a random wallpaper that is not the current one
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

    # Apply the selected wallpaper
    sleep 0.5
    swww img "$WALLPAPER" --transition-fps 60 --transition-type grow --transition-duration 1
  '';
in {
  config = mkIf env.programs.wallpapers.swww.enable {
    home.packages = [wallpaper-random];
  };
}
