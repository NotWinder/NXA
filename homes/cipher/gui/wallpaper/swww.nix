{
  inputs',
  osConfig,
  lib,
  ...
}: let
  inherit (builtins) elem;
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules;

  prg = modules.usrEnv.programs;
  swww = inputs'.swww.packages.default;
in {
  config = mkIf (elem "swww" prg.wallpapers) {
    services.swww = {
      enable = true;
      package = swww;
    };
  };
}
