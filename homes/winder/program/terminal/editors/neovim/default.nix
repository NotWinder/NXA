{ config, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    ripgrep
  ];
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
