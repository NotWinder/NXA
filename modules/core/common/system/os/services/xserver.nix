{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
in {
  config = mkIf sys.video.enable {
    services.xserver = {
      enable = true;
      displayManager = {
        gdm.enable = false;
        lightdm.enable = false;
      };
    };
  };
}
