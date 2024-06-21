{ config, ... }:
## Nvidia
{
  services.xserver.videoDrivers = [ "nvidia" ];
  boot.blacklistedKernelModules = [ "nouveau" ];

  hardware = {
    graphics = {
      enable = true;
    };


    nvidia = {
      modesetting.enable = true;
      forceFullCompositionPipeline = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };
}
