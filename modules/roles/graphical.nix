{ lib, ... }: {
  flake.modules.nixos.graphical = {
    config = {
      system.nixos.tags = [ "graphical" ];

      custom.system = {
        video.enable = lib.mkDefault true;
        sound.enable = lib.mkDefault true;
        bluetooth.enable = lib.mkDefault true;

        # Desktops run VMs/containers and Tor (the latter only takes effect
        # with the workstation profile).
        virtualisation = {
          enable = lib.mkDefault true;
          qemu.enable = lib.mkDefault true;
          docker.enable = lib.mkDefault true;
        };
        security.tor.enable = lib.mkDefault true;
      };
    };
  };
}
