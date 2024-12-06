{
  inputs',
  osConfig,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;

  sys = modules.system;
  prg = sys.programs;
in {
  config = mkIf prg.zen.enable {
    home.packages = [
      inputs'.zenf.packages.default
    ];
  };
}
