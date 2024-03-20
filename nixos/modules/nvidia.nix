{ config, ... }:
## Nvidia
{
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
      forceFullCompositionPipeline = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      prime.nvidiaBusId = "PCI:1:0:0";
      prime.intelBusId = "PCI:0:2:0";
      prime.sync.enable = true;
    };
  };
}
