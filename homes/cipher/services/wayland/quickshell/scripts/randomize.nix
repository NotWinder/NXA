{
  inputs',
  pkgs,
  ...
}: let
  winpaper = inputs'.winpaper.packages;
  wallpaper-random = pkgs.writeShellScriptBin "wallpaper-random" ''
    TOP_DIR=${winpaper.wallpkgs}
    WALLPAPER_DIR="$TOP_DIR/share/wallpapers/"

    # Apply the selected wallpaper
    sleep 0.5
    caelestia wallpaper -r "$WALLPAPER_DIR"
  '';
in {
  home.packages = [wallpaper-random];
}
