{pkgs, ...}: let
  mainUser = "winder"; # The Main User of the host
in {
  config.modules.system = {
    mainUser = mainUser;
    users = [mainUser];
    homePath = "/home/${mainUser}";
    defaultUserShell = pkgs.zsh;
    autoLogin = true;

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
      plymouth = {
        enable = true;
        withThemes = false;
      };
    };

    containers = {
      enabledContainers = ["alpha"];
    };

    video.enable = true;
    sound.enable = true;
    bluetooth.enable = true;
    printing.enable = false;
    emulation.enable = true;

    virtualization = {
      enable = true;
      qemu.enable = true;
      docker.enable = true;
    };

    networking = {
      optimizeTcp = true;
      nftables.enable = true;
      tailscale = {
        enable = true;
        isClient = true;
        isServer = false;
      };
    };

    security = {
      tor.enable = true;
      fixWebcam = false;
      lockModules = true;
      auditd.enable = true;
    };

    programs = {
      cli.enable = true;
      gui.enable = true;

      #spotify.enable = true;
      obs.enable = true;
      zen.enable = true;

      git.signingKey = "0xAF26552424E53993 ";

      gaming = {
        enable = true;
      };

      default = {
        terminal = "alacritty";
      };
    };
  };
}
