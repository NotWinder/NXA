##  Bootloader UEFI
{lib, ...}: {
  boot.loader = {
    grub = {
      enable = lib.mkForce true;
      device = lib.mkForce "nodev";
      useOSProber = lib.mkForce true;
      efiSupport = lib.mkForce true;
    };
    efi.canTouchEfiVariables = lib.mkForce true;
  };
}
