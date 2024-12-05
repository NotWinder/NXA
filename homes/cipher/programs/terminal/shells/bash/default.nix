{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  # copy paste done right
  XDG_CONFIG_HOME = "$HOME/.config";
  inherit (lib) mkIf;
  cfg = osConfig.modules.system;
in {
  config = mkIf (cfg.defaultUserShell == pkgs.bash) {
    programs.bash = {
      enable = true;
      enableVteIntegration = true;
      historyControl = ["erasedups" "ignoredups" "ignorespace"];
      historyFile = "${XDG_CONFIG_HOME}/bash/bash-history";
      shellAliases = import ./config/alias.nix;
      sessionVariables = import ./config/variables.nix;
      initExtra = import ./config/extra.nix;
      logoutExtra = import ./config/logout.nix;
    };
  };
}
