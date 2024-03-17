##  Bootloader UEFI
{
  boot = {
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        fsIdentifier = "label";
        efiSupport = true;
      };
      efi.canTouchEfiVariables = true;
    };
  };
}
