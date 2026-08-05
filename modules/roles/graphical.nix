{ lib, ... }: {
  flake.modules.nixos.graphical = {
    config = {
      system.nixos.tags = [ "graphical" ];

      custom.system = {
        video.enable = lib.mkDefault true;
        sound.enable = lib.mkDefault true;
        bluetooth.enable = lib.mkDefault true;
      };
    };
  };
}
