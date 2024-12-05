{
  config.modules.system = {
    mainUser = "winder";
    users = ["winder"];
    homePath = "/home/winder";
    autoLogin = true;

    fs.enabledFilesystems = ["btrfs" "vfat" "ntfs" "exfat"];

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

    video.enable = true;
    sound.enable = true;
    bluetooth.enable = true;
    printing.enable = false;
    emulation.enable = true;

    programs = {
      cli.enable = true;
      gui.enable = true;

      chromium.enable = true;

      default = {
        terminal = "alacritty";
      };
    };
  };
}
