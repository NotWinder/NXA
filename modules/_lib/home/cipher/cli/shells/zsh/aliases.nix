{ pkgs, lib, osConfig, ... }:
let
  inherit (lib) mkIf;
  aliases = import ../aliases.nix { inherit pkgs lib; };
in
{
  config = mkIf (osConfig.custom.system.defaultUserShell == pkgs.zsh) {
    programs.zsh.shellAliases = aliases.common // aliases.posix;
  };
}
