{config, lib, pkgs, osConfig, ...}:
let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  inherit (osConfig) custom;

  prg = custom.usrEnv.programs;
in
{
  config = mkIf (elem "brave" prg.browsers) {
    home.packages = [
      pkgs.brave
    ];
  };
}
