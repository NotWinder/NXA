{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  inherit (config) modules;

  prg = modules.usrEnv.programs;
in {
  config.hm = mkIf (elem "librewolf" prg.browsers) {
    programs.librewolf = {
      enable = true;
      package = pkgs.librewolf;
    };
  };
}
