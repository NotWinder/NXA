{pkgs, ...}: let
  mainUser = "winder"; # The Main User of the host
in {
  config.modules.system = {
    mainUser = mainUser;
    users = [mainUser];
    homePath = "/home/${mainUser}";
    defaultUserShell = pkgs.zsh;
    autoLogin = true;

    services = {
      jellyfin.enable = true;
      prowlarr.enable = true;
      radarr.enable = true;
      sonarr.enable = true;
      xray.enable = true;
    };

    fs = {
      enabledFilesystems = ["btrfs" "vfat" "ntfs" "exfat"];
      zfs.enable = true;
    };

    boot = {
      loader = "grub";
      secureBoot = false;
      enableKernelTweaks = true;
      initrd.enableTweaks = true;
      loadRecommendedModules = true;
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

    #networking = {
    #  optimizeTcp = true;
    #  nftables.enable = true;
    #  tailscale = {
    #    enable = true;
    #    isClient = true;
    #    isServer = false;
    #  };
    #};

    security = {
      tor.enable = true;
      fixWebcam = false;
    };
  };
}
