{
  osConfig,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  prg = osConfig.modules.system.programs.terminals;
in {
  config = mkIf prg.alacritty.enable {
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
