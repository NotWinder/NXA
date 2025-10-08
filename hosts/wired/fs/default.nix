{inputs, ...}: let
  # This will be evaluated during installation
  # Pick the largest disk, or first nvme, or first disk, etc.
  diskDevice =
    # You can set this via environment variable during install
    if builtins.getEnv "DISKO_DEVICE" != ""
    then builtins.getEnv "DISKO_DEVICE"
    else "/dev/sda"; # fallback
in {
  config = {
    imports = [inputs.disko.nixosModules.disko];
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
                  extraArgs = ["-f"]; # Override existing partition
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
