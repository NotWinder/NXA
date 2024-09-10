##  Bootloader UEFI
{
  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      useOSProber = true;
      efiSupport = true;
      gfxmodeEfi= "1440x900";
    };
    efi.canTouchEfiVariables = true;
  };
}
