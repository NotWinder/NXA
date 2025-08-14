{
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  inherit (osConfig) modules;

  prg = modules.usrEnv.programs;
in {
  config = mkIf (elem "floorp" prg.browsers) {
    programs.floorp = {
      enable = true;
    };
  };
}
