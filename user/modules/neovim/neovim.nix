{ config, pkgs, inputs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
  home.file."${config.xdg.configHome}/nvim" = {
    source = ./nvim;
    recursive = true;
  };

}
