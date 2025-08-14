{
  osConfig,
  lib,
  ...
}: let
  inherit (builtins) elem;
  inherit (lib) mkIf;
  inherit (osConfig) modules;

  prg = modules.usrEnv.programs;
in {
  config = mkIf (elem "ghostty" prg.terminals) {
    programs.ghostty = {
      enable = true;
    };
  };
}
