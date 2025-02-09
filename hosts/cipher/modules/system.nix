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

    bluetooth.enable = true;
    emulation.enable = true;
    printing.enable = false;
    sound.enable = true;
    video.enable = true;

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
      auditd.enable = true;
    };

    programs = {
      cli.enable = true;
      gui.enable = true;

      obs.enable = true;

      git.signingKey = "0xB7747DE9EEAAE164";

      gaming.enable = true;

      terminals = {
        alacritty.enable = true;
      };

      default = {
        terminal = "alacritty";
        browser = "zen";
      };
    };
  };
}
