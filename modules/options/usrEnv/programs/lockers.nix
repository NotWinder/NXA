{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.types) package;
  inherit (lib.options) mkOption mkEnableOption;

  pkg = pkgs.swaylock-effects;
in {
  options.modules.usrEnv.programs.screenlock = {
    swaylock.enable = mkEnableOption "swaylock screenlocker";

    package = mkOption {
      type = package;
      default = pkg;
      readOnly = true;
      description = "The screenlocker package";
    };
  };
}
