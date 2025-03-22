{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config) modules;

  prg = modules.usrEnv.programs;
in {
  config = mkIf prg.cli.enable {
    programs.less.enable = true;
  };
}
