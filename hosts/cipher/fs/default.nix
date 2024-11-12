{
  config = {
    fileSystems = {
      "/boot" = {
        device = "/dev/disk/by-uuid/D619-D553";
        fsType = "vfat";
      };

      "/" = {
        device = "/dev/disk/by-uuid/55b0f02e-8949-42e1-86ad-60559647f1fd";
        fsType = "btrfs";
        options = ["subvol=root" "compress=zstd" "noatime"];
      };

      "/nix" = {
        device = "/dev/disk/by-uuid/55b0f02e-8949-42e1-86ad-60559647f1fd";
        fsType = "btrfs";
        options = ["subvol=nix" "compress=zstd" "noatime"];
      };

      "/home" = {
        device = "/dev/disk/by-uuid/55b0f02e-8949-42e1-86ad-60559647f1fd";
        fsType = "btrfs";
        options = ["subvol=home" "compress=zstd"];
      };

      #"/persist" = {
      #  device = "/dev/disk/by-uuid/55b0f02e-8949-42e1-86ad-60559647f1fd";
      #  fsType = "btrfs";
      #  options = ["subvol=persist" "compress=zstd" "noatime"];
      #};

      #"/var/log" = {
      #  device = "/dev/disk/by-uuid/55b0f02e-8949-42e1-86ad-60559647f1fd";
      #  fsType = "btrfs";
      #  options = ["subvol=log" "compress=zstd" "noatime"];
      #};
    };
    swapDevices = [
      {
        device = "/var/lib/swapfile";
        size = 8 * 1024;
      }
    ];
  };
}
