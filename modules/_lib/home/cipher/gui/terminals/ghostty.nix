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
  config.hm = mkIf (elem "ghostty" prg.terminals) {
    programs.ghostty = {
      enable = true;
    };
  };
}
