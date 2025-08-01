{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;
  inherit (osConfig.modules.style.colorScheme) colors;

  env = modules.usrEnv;
in {
  config = mkIf env.programs.screenlock.swaylock.enable {
    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
      settings = {
        clock = true;
        font = "Work Sans";
        show-failed-attempts = false;
        indicator = true;
        indicator-radius = 200;
        indicator-thickness = 20;
        line-uses-ring = false;
        grace = 3;
        grace-no-mouse = true;
        grace-no-touch = true;
        datestr = "%d/%m/%Y";
        fade-in = "0.1";
        ignore-empty-password = true;
      };
    };
  };
}
