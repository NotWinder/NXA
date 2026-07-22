{ pkgs, ... }:
{
  config.custom.system = {
    defaultUserShell = pkgs.zsh;

    services = {
      sing-box.enable = true;
    };

    fs = {
      enabledFilesystems = [ "btrfs" "vfat" "ntfs" "exfat" ];
    };

    boot = {
      loader = "grub";
      grub.device = "/dev/sda";
      isUEFI = false;
      secureBoot = false;
      tmpOnTmpfs = false;
    };

    virtualisation = {
      enable = false;
      qemu.enable = false;
      docker.enable = false;
    };

    security = {
      tor.enable = false;
      fixWebcam = false;
    };
  };
}
