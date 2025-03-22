{
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;

  prg = modules.usrEnv.programs;
in {
  config = mkIf prg.browsers.floorp.enable {
    programs.floorp = {
      enable = true;
    };
  };
}
