{inputs, ...}: let
  diskDevice =
    if builtins.getEnv "DISKO_DEVICE" != ""
    then builtins.getEnv "DISKO_DEVICE"
    else "/dev/sda";
in {
  imports = [inputs.disko.nixosModules.disko];
  config = {
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = diskDevice;
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                priority = 1;
                name = "ESP";
                start = "1M";
                end = "1536M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = ["umask=0077"];
                };
              };
              root = {
                size = "100%";
                content = {
                  type = "btrfs";
                  extraArgs = ["-f"];
                  subvolumes = {
                    "/root" = {
                      mountOptions = ["compress=zstd" "noatime"];
                      mountpoint = "/";
                    };
                    "/home" = {
                      mountOptions = ["compress=zstd" "relatime"];
                      mountpoint = "/home";
                    };
                    "/nix" = {
                      mountOptions = ["compress=zstd" "noatime"];
                      mountpoint = "/nix";
                    };
                    "/snapshots" = {
                      mountOptions = ["compress=zstd" "noatime"];
                      mountpoint = "/snapshots";
                    };
                    "/swap" = {
                      mountOptions = ["noatime"];
                      mountpoint = "/swap";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
    swapDevices = [
      {
        device = "/swap/swapfile";
        size = 8 * 1024;
      }
    ];
  };
}
