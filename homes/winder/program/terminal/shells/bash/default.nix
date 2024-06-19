## Bash settings
{ config, ... }:

{
  home.file."${config.xdg.configHome}/bash" = {
    source = ./bash;
    recursive = true;
  };
  programs.bash = {
    enable = true;
    initExtra = "source ${config.xdg.configHome}/bash/bashrc";
  };
}
