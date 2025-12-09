{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.modules.system;
in {
  config = mkIf (cfg.fs.zfs.enable) {
    boot = {
      kernelPackages = pkgs.linuxPackages_xanmod_latest;
      supportedFilesystems = ["zfs"];
      initrd.supportedFilesystems = ["zfs"];
    };
  };
}
