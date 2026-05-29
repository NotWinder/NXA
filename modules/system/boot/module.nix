{
  imports = [
    #./analasis.nix
    ./loaders # per-bootloader configurations
    ./secure-boot.nix # secure boot module
    ./generic.nix # generic configuration, such as kernel and tmpfs setup
    ./plymouth.nix # plymouth boot splash
  ];
  boot.blacklistedKernelModules = ["serial8250"];
  boot.kernelParams = ["zfs.zfs_arc_max=${toString (16 * 1024 * 1024 * 1024)}"];
 #services.bootMonitor.enable = true;
}
