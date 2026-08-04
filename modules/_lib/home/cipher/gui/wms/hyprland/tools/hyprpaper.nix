{ inputs'
, config
, lib
, ...
}:
let
  inherit (lib) mkIf;

  hyprpaper = inputs'.hyprpaper.packages.default;
in
{
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
