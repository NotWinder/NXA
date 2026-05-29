{ config
, lib
, ...
}:
let
  inherit (lib) mkIf;
in
{
  config.custom.usrEnv.programs = mkIf config.custom.profiles.gaming.enable {
    gaming.enable = true;
  };
}
