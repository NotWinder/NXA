{pkgs}:
pkgs.writeShellScriptBin "hyprpapersh" ''
  hyprctl hyprpaper unload all
  hyprctl hyprpaper preload "$1"
  hyprctl hyprpaper wallpaper ",$1"
''
