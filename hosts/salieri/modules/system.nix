{
  config.custom.system = {
    services = {
      #jellyfin.enable = true;
      #lidarr.enable = true;
      #prowlarr.enable = true;
      #radarr.enable = true;
      #sing-box.enable = true;
      #sonarr.enable = true;
    };

    fs = {
      enabledFilesystems = [ "btrfs" "vfat" "ntfs" "exfat" ];
      #zfs.enable = true;
    };

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
