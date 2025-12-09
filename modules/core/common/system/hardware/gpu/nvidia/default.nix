{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
in {
  options.custom.hardware.nvidia = {
    enable = lib.mkEnableOption "Enable NVIDIA GPU support";
    isHybrid = lib.mkEnableOption "Indicates if the system is a hybrid GPU setup (e.g., NVIDIA + AMD)";
    nvidiaOpen = lib.mkEnableOption "Use the open NVIDIA kernel module instead of the proprietary one";
  };
  config = mkIf config.custom.hardware.nvidia.enable {
    nixpkgs.config.allowUnfree = true;
    boot.kernelParams = [
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
    ];
    services.xserver = {
      videoDrivers = ["nvidia"];
    };
    environment = {
      variables = {
        #WLR_NO_HARDWARE_CURSORS = "1";
        #GBM_BACKEND = "nvidia-drm";
        #LIBVA_DRIVER_NAME = "nvidia";

        # Force NVIDIA for Vulkan - Use ONLY ONE of these methods
        VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/nvidia_icd.i686.json";
        DRI_PRIME = "1";
        # Hide Mesa software drivers
        DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS_1 = "1";

        XWAYLAND_NO_GLAMOR = "1";
      };
      sessionVariables = {
        # For DXVK/Proton to prefer NVIDIA
        DXVK_FILTER_DEVICE_NAME = "NVIDIA";
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
        prime = mkIf config.custom.hardware.nvidia.isHybrid {
          nvidiaBusId = "PCI:1:0:0";
          amdgpuBusId = "PCI:6:0:0";
          reverseSync.enable = true;
          #offload = {
          #  enable = true;
          #  enableOffloadCmd = true;
          #};
        };
        powerManagement = mkIf config.custom.hardware.nvidia.isHybrid {
          enable = true;
          finegrained = true;
        };
        open = config.custom.hardware.nvidia.nvidiaOpen;
        nvidiaSettings = true;
        forceFullCompositionPipeline = false;
      };
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          nvidia-vaapi-driver
          libglvnd
          nvidia-vaapi-driver
        ];
        extraPackages32 = with pkgs.pkgsi686Linux; [
          libgbm
        ];
      };
    };
  };
}
