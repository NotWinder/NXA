{
  config,
  lib,
  ...
}: let
  inherit (builtins) elem;
  inherit (lib) mkIf;
  inherit (config) modules;

  prg = modules.usrEnv.programs;
in {
  config.hm = mkIf (elem "ghostty" prg.terminals) {
    programs.ghostty = {
      enable = true;
    };
  };
}
