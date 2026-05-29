{ config
, pkgs
, lib
, ...
}:
let
  inherit (lib) mkIf;

  cfg = config.custom.system;
in
{
  config = mkIf (cfg.fs.zfs.enable) {
    boot = {
      kernelPackages = pkgs.linuxPackages;
      supportedFilesystems = [ "zfs" ];
      initrd.supportedFilesystems = [ "zfs" ];
    };
  };
}
