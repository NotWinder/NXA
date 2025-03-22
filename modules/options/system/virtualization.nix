{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.modules.system.virtualization = {
    enable = mkEnableOption "virtualization";

    distrobox.enable = mkEnableOption "distrobox";
    docker.enable = mkEnableOption "docker";
    libvirt.enable = mkEnableOption "libvirt";
    podman.enable = mkEnableOption "podman";
    qemu.enable = mkEnableOption "qemu";
    waydroid.enable = mkEnableOption "waydroid";
  };
}
