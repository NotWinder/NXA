{ config
, pkgs
, lib
, ...
}:
let
  inherit (builtins) elem;
  inherit (lib) mkIf;

  dev = config.custom.device;
in
{
  config = mkIf (elem dev.gpu.type [ "nvidia" "hybrid-nv" ]) {
    nixpkgs.config.allowUnfree = true;
    #services.xserver.videoDrivers = ["nvidia"];
    services.xserver.videoDrivers = [ "nvidia" "amdgpu" ];

    #services.xserver.videoDrivers = ["amdgpu"];

    environment = {
      variables = {
        #WLR_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card2";

        # Force NVIDIA for Vulkan - Use ONLY ONE of these methods
        #VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/nvidia_icd.i686.json";
        #DRI_PRIME = "1";
        # Hide Mesa software drivers
        #DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS_1 = "1";

        #XWAYLAND_NO_GLAMOR = "1";
      };
      sessionVariables = {
        # For DXVK/Proton to prefer NVIDIA
        #DXVK_FILTER_DEVICE_NAME = "NVIDIA";
      };
      systemPackages = with pkgs; [
        nvtopPackages.full
        libgbm
        mesa-demos
        # vulkan
        vulkan-tools
        vulkan-loader
        vulkan-validation-layers
        vulkan-extension-layer

        wayland
        wayland-protocols
        libxkbcommon
        # libva
        libva
        libva-utils
        # NVIDIA-specific packages
        nvidia-vaapi-driver
        egl-wayland
      ];
    };
    hardware = {
      enableRedistributableFirmware = true;
      enableAllFirmware = true;
      nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.production;
        modesetting.enable = true;
        prime = mkIf dev.gpu.nvidia.isHybrid {
          nvidiaBusId = "PCI:1:0:0";
          amdgpuBusId = "PCI:6:0:0";

          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
        };
        powerManagement = mkIf dev.gpu.nvidia.isHybrid {
          enable = true;
          finegrained = true;
        };
        open = dev.gpu.nvidia.nvidiaOpen;
        nvidiaSettings = true;
        forceFullCompositionPipeline = false;
      };
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          nvidia-vaapi-driver
          libglvnd
        ];
        extraPackages32 = with pkgs.pkgsi686Linux; [
          libgbm
        ];
      };
    };
  };
}
