{ config, lib, pkgs, osConfig, ... }:
let
  # copy paste done right
  XDG_CONFIG_HOME = "$HOME/.config";
  inherit (lib) mkIf;
  cfg = osConfig.custom.system;
  aliases = import ../aliases.nix { inherit pkgs lib; };
in
{
  config = mkIf (cfg.defaultUserShell == pkgs.bash) {
    programs.bash = {
      enable = true;
      enableVteIntegration = true;
      historyControl = [ "erasedups" "ignoredups" "ignorespace" ];
      historyFile = "${XDG_CONFIG_HOME}/bash/bash-history";
      shellAliases = aliases.common // aliases.posix;
      sessionVariables = import ./config/variables.nix;
      initExtra = import ./config/extra.nix;
      logoutExtra = import ./config/logout.nix;
    };
  };
}
