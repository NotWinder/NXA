{ config, pkgs, inputs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      import = [
        "~/.config/alacritty/themes/themes/marine_dark.toml"
      ];
      window = {
        opacity = 0.8;
      };
      font = {
        normal.family = "MesloLGL Nerd Font";
      };
      colors.primary = {
        background = "#000009";
      };
    };
  };
  home.file."${config.xdg.configHome}/alacritty" = {
    source = ./alacritty;
    recursive = true;
  };
}
