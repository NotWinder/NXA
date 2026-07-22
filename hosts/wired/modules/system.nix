{
  config.custom.system = {
    services = {
      sing-box.enable = true;
    };

    fs = {
      enabledFilesystems = [ "btrfs" "vfat" "ntfs" "exfat" ];
    };

    enableSshSecrets = true;

    boot = {
      isUEFI = true;
      loader = "grub";
      plymouth.enable = false;
      secureBoot = false;
      tmpOnTmpfs = false;
    };

    bluetooth.enable = true;
    sound.enable = true;
    video.enable = true;

    virtualisation = {
      enable = true;
      qemu.enable = true;
      docker.enable = true;
    };

    security = {
      tor.enable = true;
      fixWebcam = false;
    };
  };
}
