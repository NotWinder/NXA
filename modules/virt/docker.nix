{ lib
, config
, ...
}:
let
  inherit (lib) mkIf;
  inherit (config) custom;

  virt = custom.system.virtualisation;
in
{
  config = mkIf virt.docker.enable {
    virtualisation = {
      docker = {
        enable = true;
        storageDriver = virt.docker.storageDriver;
        extraOptions = "--data-root=${virt.docker.dataRoot}";
      };
    };
  };
}
