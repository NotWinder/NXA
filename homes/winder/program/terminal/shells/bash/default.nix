let
  # copy paste done right
  XDG_CONFIG_HOME = "$HOME/.config";
  XDG_CACHE_HOME = "$HOME/.cache";
  XDG_DATA_HOME = "$HOME/.local/share";
  XDG_STATE_HOME = "$HOME/.local/state";
  XDG_BIN_HOME = "$HOME}/.local/bin";
  XDG_RUNTIME_DIR = "/run/user/$UID";
in
{
  programs.bash = {
    enable = true;
    enableVteIntegration = true;
    historyControl = [ "erasedups" "ignoredups" "ignorespace" ];
    historyFile = "${XDG_CONFIG_HOME}/bash/bash-history";
    shellAliases = import ./config/alias.nix;
    sessionVariables = import ./config/variables.nix;
    initExtra = import ./config/extra.nix;
    logoutExtra = import ./config/logout.nix;
  };
}
