{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config) modules;

  virt = modules.system.virtualisation;
in {
  config = mkIf virt.docker.enable {
    virtualisation = {
      docker = {
        enable = true;
        storageDriver = "btrfs";
      };
    };
  };
}
