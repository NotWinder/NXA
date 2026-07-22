{ lib, ... }:
{
  config = {
    system.nixos.tags = ["headless"];

    custom.system = {
      video.enable = lib.mkDefault false;
      sound.enable = lib.mkDefault false;
      bluetooth.enable = lib.mkDefault false;
    };
  };
}
