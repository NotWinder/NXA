{
  config,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkIf;

  cfg = config.modules.system;
in {
  config = mkIf (cfg.boot.loader == "grub") {
    boot.loader = {
      grub = {
        enable = mkDefault true;
        useOSProber = true;
        efiSupport = cfg.boot.isUEFI;
        enableCryptodisk = mkDefault false;
        device = cfg.boot.grub.device;
      };
    };
  };
}
