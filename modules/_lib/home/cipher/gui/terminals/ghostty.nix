{config, lib, osConfig, ...}:
let
  inherit (builtins) elem;
  inherit (lib) mkIf;
  inherit (osConfig) custom;

  prg = custom.usrEnv.programs;
in
{
  config = mkIf (elem "ghostty" prg.terminals) {
    programs.ghostty = {
      enable = true;
    };
  };
}
