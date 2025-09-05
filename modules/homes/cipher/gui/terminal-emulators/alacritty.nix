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
  config.hm = mkIf (elem "alacritty" prg.terminals) {
    programs.alacritty = {
      enable = true;
      settings = {
        window = {
          padding = {
            x = 20;
            y = 0;
          };
        };
      };
    };
  };
}
