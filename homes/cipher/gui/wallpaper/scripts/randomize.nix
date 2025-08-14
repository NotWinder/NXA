{
  inputs',
  pkgs,
  osConfig,
  lib,
  ...
}: let
  inherit (builtins) elem;
  inherit (lib) mkIf;
  inherit (osConfig) modules;
  prg = modules.usrEnv.programs;

  winpaper = inputs'.winpaper.packages;
  wallpaper-random =
    if (elem "hyprpaper" prg.wallpapers)
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
    else
      (
        if (elem "swww" prg.wallpapers)
        then
          pkgs.writeShellScriptBin "wallpaper-random" ''
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
          ''
        else ""
      );
in {
  config = mkIf (!elem "none" prg.wallpapers) {
    home.packages = [wallpaper-random];
  };
}
