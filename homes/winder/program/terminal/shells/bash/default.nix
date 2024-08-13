{
  programs.bash = {
    enable = true;
    enableVteIntegration = true;
    historyControl = ["erasedups" "ignoredups" "ignorespace"];
    historyFile = "$XDG_CONFIG_HOME/bash/bash-history";
    shellAliases = import ./config/alias.nix;
    sessionVariables = import ./config/variables.nix;
    initExtra = import ./config/extra.nix;
    logoutExtra = import ./config/logout.nix;
  };
}
