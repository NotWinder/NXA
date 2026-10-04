{ pkgs, lib, osConfig, ... }:
let
  inherit (lib) mkIf;
  aliases = import ../aliases.nix { inherit pkgs lib; };
in
{
  config = mkIf (osConfig.custom.system.defaultUserShell == pkgs.fish) {
    programs.fish.shellAliases = aliases.common;
  };
}
