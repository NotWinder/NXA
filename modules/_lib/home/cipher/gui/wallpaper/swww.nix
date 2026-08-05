{config, lib, osConfig, ...}:
let
  inherit (builtins) elem;
  inherit (lib.modules) mkIf;
  inherit (osConfig) custom;

  prg = custom.usrEnv.programs;
in
{
  config = mkIf (elem "swww" prg.wallpapers) {
    services.swww = {
      enable = true;
    };
  };
}
