{ config
, lib
, ...
}:
let
  inherit (builtins) elem;
  inherit (lib) mkIf;
  inherit (config) custom;

  prg = custom.usrEnv.programs;
in
{
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
