{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  inherit (config) modules;

  prg = modules.usrEnv.programs;
in {
  config.hm = mkIf (elem "brave" prg.browsers) {
    home.packages = [
      pkgs.brave
    ];
  };
}
