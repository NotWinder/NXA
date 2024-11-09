{
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
  #home.file."${config.xdg.configHome}/alacritty" = {
  #  source = ./alacritty;
  #  recursive = true;
  #};
}
