{ config
, lib
, pkgs
, ...
}:
let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  inherit (config) custom;

  prg = custom.usrEnv.programs;
in
{
  config.hm = mkIf (elem "brave" prg.browsers) {
    home.packages = [
      pkgs.brave
    ];
  };
}
