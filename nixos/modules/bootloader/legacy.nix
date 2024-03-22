##  Bootloader UEFI
{
  boot = {
    loader = {
      grub = {
        enable = true;
        device = "/dev/sda";
        fsIdentifier = "label";
      };
    };
  };
}
