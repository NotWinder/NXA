{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  inherit (osConfig) modules;

  prg = modules.usrEnv.programs;
in {
  config = mkIf (elem "librewolf" prg.browsers) {
    programs.librewolf = {
      enable = true;
      package = pkgs.librewolf;
    };
  };
}
