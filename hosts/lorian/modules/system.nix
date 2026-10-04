{ pkgs, ... }:
{
  config.custom.system = {
    defaultUserShell = pkgs.zsh;

    services = {
      sing-box.enable = true;
    };

    # legacy BIOS boot
    boot = {
      grub.device = "/dev/sda";
      isUEFI = false;
    };
  };
}
