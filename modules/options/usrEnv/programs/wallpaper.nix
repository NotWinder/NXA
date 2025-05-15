{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.modules.usrEnv.programs.wallpapers = {
    hyprpaper.enable = mkEnableOption "A Blazing Fast Wallpaper Utility For Hyprland";
    swww.enable = mkEnableOption "A Solution to your Wayland Wallpaper Woes";
  };
}
