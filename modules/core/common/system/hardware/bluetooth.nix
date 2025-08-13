{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system.bluetooth;
in {
  config = mkIf sys.enable {
    modules.system.boot.extraKernelParams = ["btusb"];

    hardware.bluetooth = {
      enable = true;
      package = pkgs.bluez-experimental;
      powerOnBoot = true;
      disabledPlugins = ["sap"];
      settings = {
        General = {
          JustWorksRepairing = "always";
          MultiProfile = "multiple";
          Experimental = true;
          UserspaceHID = true;
        };
      };
    };

    ## https://nixos.wiki/wiki/Bluetooth
    #services.blueman.enable = true;
  };
}
