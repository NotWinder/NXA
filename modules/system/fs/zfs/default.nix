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

      # The 26.11 default, set explicitly to silence the transition warning.
      # Only affects importing a ZFS root pool in the initrd; no host has one
      # (cipher's root is btrfs, ZFS holds the extraPools data pool).
      zfs.forceImportRoot = false;
      supportedFilesystems = [ "zfs" ];
      initrd.supportedFilesystems = [ "zfs" ];

      # Cap ZFS ARC memory (16 GiB) so it does not starve the rest of the system
      kernelParams = [ "zfs.zfs_arc_max=${toString (16 * 1024 * 1024 * 1024)}" ];
    };
  };
}
