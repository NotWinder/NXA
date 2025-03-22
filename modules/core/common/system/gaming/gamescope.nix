{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (config) modules;

  prg = modules.usrEnv.programs;
in {
  config = mkIf prg.gaming.gamescope.enable {
    programs.gamescope = {
      enable = true;
      capSysNice = true;
      package = pkgs.gamescope; # the default, here in case I want to override it
    };
  };
}
