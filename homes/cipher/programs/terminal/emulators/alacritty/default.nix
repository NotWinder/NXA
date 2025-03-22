{
  osConfig,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;

  prg = modules.usrEnv.programs;
in {
  config = mkIf prg.terminals.alacritty.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        general.import = [
          "~/.config/alacritty/themes/themes/marine_dark.toml"
        ];
        window = {
          opacity = 0.8;
          padding = {
            x = 20;
            y = 0;
          };
        };
        font = {
          normal.family = "MesloLGL Nerd Font";
          size = 14;
        };
        colors.primary = {
          background = "#000009";
        };
      };
    };
  };
}
