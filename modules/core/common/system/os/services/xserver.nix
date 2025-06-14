{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
in {
  config = mkIf sys.video.enable {
    services = {
      displayManager = {
        gdm.enable = false;
      };
      xserver = {
        enable = true;
        displayManager = {
          lightdm.enable = false;
        };
      };
    };
  };
}
