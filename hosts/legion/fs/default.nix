{
  config = {
    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/cc306aa9-9589-4ad1-b9fd-43db5bd0f438";
        fsType = "ext4";
      };

      "/home" = {
        device = "/dev/disk/by-uuid/1c7660dc-52af-4d48-9a7c-4d43ba67507f";
        fsType = "ext4";
      };

      "/boot" = {
        device = "/dev/disk/by-uuid/FB7D-7527";
        fsType = "vfat";
        options = ["fmask=0077" "dmask=0077"];
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
