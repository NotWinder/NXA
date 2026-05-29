{
  config,
  lib,
  ...
}: let
  inherit (builtins) elem;
  inherit (lib.modules) mkIf;
  inherit (config) modules;

  prg = modules.usrEnv.programs;
in {
  config.hm = mkIf (elem "swww" prg.wallpapers) {
    services.swww = {
      enable = true;
    };
  };
}
