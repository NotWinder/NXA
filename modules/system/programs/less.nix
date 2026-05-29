{ config
, lib
, ...
}:
let
  inherit (lib) mkIf;
  inherit (config) custom;

  prg = custom.usrEnv.programs;
in
{
  config = mkIf prg.cli.enable {
    programs.less.enable = true;
  };
}
