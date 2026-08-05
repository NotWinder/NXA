{lib, config, osConfig, ...}:
let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  inherit (osConfig) custom;

  prg = custom.usrEnv.programs;
in
{
  config = mkIf (elem "floorp" prg.browsers) {
    programs.floorp = {
      enable = true;
    };
  };
}
