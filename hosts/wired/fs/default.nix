{
  config = {
    fileSystems = {

  "/" =
    { device = "/dev/disk/by-uuid/0ad49081-7a4c-48e4-9ada-33663c261b55";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

  "/home" =
    { device = "/dev/disk/by-uuid/0ad49081-7a4c-48e4-9ada-33663c261b55";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

  "/nix" =
    { device = "/dev/disk/by-uuid/0ad49081-7a4c-48e4-9ada-33663c261b55";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

  "/boot" =
    { device = "/dev/disk/by-uuid/E187-7427";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
    };
    swapDevices = [
      {
        device = "/var/lib/swapfile";
        size = 8 * 1024;
      }
    ];
  };
}

