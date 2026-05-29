{ lib
, config
, ...
}:
let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  inherit (config) custom;

  prg = custom.usrEnv.programs;
in
{
  config.hm = mkIf (elem "floorp" prg.browsers) {
    programs.floorp = {
      enable = true;
    };
  };
}
