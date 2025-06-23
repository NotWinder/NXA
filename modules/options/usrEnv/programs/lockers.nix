{lib, ...}: let
  inherit (lib.options) mkEnableOption;
in {
  options.modules.usrEnv.programs.screenlock = {
    swaylock.enable = mkEnableOption "swaylock screenlocker";
    hyprlock.enable = mkEnableOption "hyprlock screenlocker";
  };
}
