{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config) modules;

  prg = modules.usrEnv.programs;
in {
  config = mkIf (prg.cli.enable) {
    programs.adb.enable = true;

    services.udev = {
      packages = [
        pkgs.android-udev-rules
      ];

      extraRules = ''
        # add my android device to adbusers
        SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", MODE="0666", GROUP="adbusers"
      '';
    };
  };
}
