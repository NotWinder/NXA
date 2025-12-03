{
  config = {
    boot.zfs.extraPools = ["zroot"];
    boot.zfs.forceImportRoot = false;
    services.zfs = {
      autoSnapshot.enable = true;
      autoScrub.enable = false;
    };

    boot.loader.grub = {
      zfsSupport = true;
    };
    fileSystems = {
      "/boot" = {
        device = "/dev/disk/by-uuid/263C-45C6";
        fsType = "vfat";
        options = ["fmask=0022" "dmask=0022"];
      };
      "/" = {
        device = "zroot/root";
        fsType = "zfs";
      };
      "/home" = {
        device = "zroot/home";
        fsType = "zfs";
      };
      "/nix" = {
        device = "zroot/nix";
        fsType = "zfs";
      };
    };
  };
}
