{config, lib, osConfig, ...}:
let
  inherit (builtins) elem;
  inherit (lib) mkIf;
  inherit (osConfig) custom;

  prg = custom.usrEnv.programs;
in
{
  config = mkIf (elem "alacritty" prg.terminals) {
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
