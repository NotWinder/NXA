{ lib, ... }:
let
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) str;
in
{
  options.custom.system.virtualisation = {
    enable = mkEnableOption "virtualisation";

    distrobox.enable = mkEnableOption "distrobox";
    docker = {
      enable = mkEnableOption "docker";
      storageDriver = mkOption {
        type = str;
        default = "overlay2";
        description = "Docker storage driver to use";
      };
      dataRoot = mkOption {
        type = str;
        default = "/var/lib/docker";
        description = "Docker data root directory";
      };
    };
    libvirt.enable = mkEnableOption "libvirt";
    podman.enable = mkEnableOption "podman";
    qemu.enable = mkEnableOption "qemu";
    waydroid.enable = mkEnableOption "waydroid";
  };
}
