{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
  prg = sys.programs;
in {
  config = mkIf prg.cli.enable {
    programs.less.enable = true;
  };
}
