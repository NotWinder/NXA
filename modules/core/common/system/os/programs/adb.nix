{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
  prg = sys.programs;
in {
  config = mkIf (prg.cli.enable || prg.cli.adb.enable) {
    programs.adb.enable = true;
  };
}
