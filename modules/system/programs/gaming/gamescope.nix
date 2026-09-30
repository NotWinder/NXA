{ config
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
      # capSysNice wraps gamescope with CAP_SYS_NICE, which breaks launching
      # it from inside Steam's sandbox (`gamescope -- %command%`). gamemode
      # already renices games.
      capSysNice = false;
    };
  };
}
