{ config
, lib
, ...
}:
let
  inherit (builtins) elem;
  inherit (lib.modules) mkIf;
  inherit (config) custom;

  prg = custom.usrEnv.programs;
in
{
  config.hm = mkIf (elem "swww" prg.wallpapers) {
    services.swww = {
      enable = true;
    };
  };
}
