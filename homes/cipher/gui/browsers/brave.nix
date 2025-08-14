{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  inherit (osConfig) modules;

  prg = modules.usrEnv.programs;
in {
  config = mkIf (elem "brave" prg.browsers) {
    home.packages = [
      pkgs.brave
    ];
  };
}
