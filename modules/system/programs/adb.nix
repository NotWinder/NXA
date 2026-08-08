{ config
, lib
, pkgs
, ...
}:
let
  inherit (lib) mkIf;
  inherit (config) custom;

  prg = custom.usrEnv.programs;
in
{
  config = mkIf prg.cli.adb.enable {
    environment.systemPackages = [
      pkgs.android-tools
    ];

    services.udev = {
      packages = [
        pkgs.android-tools
      ];

      extraRules = ''
        # add my android device to adbusers
        SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", MODE="0666", GROUP="adbusers"
      '';
    };
  };
}
