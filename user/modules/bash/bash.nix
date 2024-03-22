## Bash settings
{
  programs.bash = {
    enable = true;
    initExtra = "source /home/winder/nixflake/user/modules/bash/bash/bashrc";
    historyFile = "/home/winder/nixflake/user/modules/bash/bash/bash-history";
  };
}
