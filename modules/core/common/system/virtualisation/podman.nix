{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  sys = config.modules.system.virtualisation;
in {
  config = mkIf (sys.docker.enable || sys.podman.enable) {
    # Enable Nvidia support for Podman if the Nvidia drivers are found
    # in the list of xserver.videoDrivers.
    hardware.nvidia-container-toolkit.enable = builtins.any (driver: driver == "nvidia") config.services.xserver.videoDrivers;
    environment.systemPackages = with pkgs; [
      podman-compose
      podman-desktop
    ];

    virtualisation = {
      # Registries to search for images on `podman pull`
      containers.registries.search = [
        "docker.io"
        "quay.io"
        "ghcr.io"
        "gcr.io"
      ];

      podman = {
        enable = true;

        # Make Podman backwards compatible with Docker socket interface.
        # Certain interface elements will be different, but unless any
        # of said values are hardcoded, it should not pose a problem
        # for us.
        dockerCompat = true;
        dockerSocket.enable = true;

        defaultNetwork.settings.dns_enabled = true;

        # Prune images and containers periodically
        autoPrune = {
          enable = true;
          flags = ["--all"];
          dates = "weekly";
        };
      };
    };
  };
}
