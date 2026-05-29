{ config
, pkgs
, lib
, ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (config) custom;

  prg = custom.usrEnv.programs;
in
{
  config = mkIf prg.gaming.gamescope.enable {
    programs.gamescope = {
      enable = true;
      capSysNice = true;
      package = pkgs.gamescope;
    };
  };
}
