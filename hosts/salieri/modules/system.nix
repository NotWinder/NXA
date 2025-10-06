{pkgs, ...}: let
  mainUser = "winder"; # The Main User of the host
in {
  config.modules.system = {
    mainUser = mainUser;
    users = [mainUser];
    homePath = "/home/${mainUser}";
    defaultUserShell = pkgs.fish;
    autoLogin = true;

    services = {
      #jellyfin.enable = true;
      #lidarr.enable = true;
      #prowlarr.enable = true;
      #radarr.enable = true;
      #sing-box.enable = true;
      #sonarr.enable = true;
    };

    fs = {
      enabledFilesystems = ["btrfs" "vfat" "ntfs" "exfat"];
      #zfs.enable = true;
    };

    boot = {
      enableKernelTweaks = true;
      initrd.enableTweaks = true;
      isUEFI = true;
      loadRecommendedModules = true;
      loader = "grub";
      plymouth.enable = false;
      secureBoot = false;
      tmpOnTmpfs = false;
    };

    bluetooth.enable = true;
    printing.enable = false;
    sound.enable = true;
    video.enable = true;

    virtualization = {
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
