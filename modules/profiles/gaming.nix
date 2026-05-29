{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
in {
  config.modules.usrEnv.programs = mkIf config.modules.profiles.gaming.enable {
    gaming.enable = true;
  };
}
