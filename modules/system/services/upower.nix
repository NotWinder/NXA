{ lib, ... }: {
  services.upower.enable = true;
  services.power-profiles-daemon.enable = lib.mkDefault false;
}
