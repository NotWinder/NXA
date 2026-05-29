{
  inputs',
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  hyprpaper = inputs'.hyprpaper.packages.default;
in {
  options.custom.programs.hyprpaper = {
    enable = lib.mkEnableOption "Hyprpaper wallpaper manager";
  };
  config.hm = mkIf config.custom.programs.hyprpaper.enable {
    services.hyprpaper = {
      enable = true;
      package = hyprpaper;
      settings = {
        ipc = "on";
        splash = false;
      };
    };
  };
}
