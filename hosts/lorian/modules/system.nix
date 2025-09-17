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
      sing-box.enable = true;
    };

    fs = {
      enabledFilesystems = ["btrfs" "vfat" "ntfs" "exfat"];
    };

    boot = {
      loader = "grub";
      grub.device = "/dev/sda";
      isUEFI = false;
      secureBoot = false;
      enableKernelTweaks = true;
      initrd.enableTweaks = true;
      loadRecommendedModules = true;
      tmpOnTmpfs = false;
    };

    bluetooth.enable = false;
    printing.enable = false;
    sound.enable = false;
    video.enable = false;

    virtualization = {
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
