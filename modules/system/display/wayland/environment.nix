{ config
, lib
, pkgs
, ...
}:
let
  inherit (lib) mkIf optionalAttrs;

  sys = config.custom.system;
  dev = config.custom.device;

  isNvidiaHybrid = builtins.elem dev.gpu.type [ "nvidia" "hybrid-nv" ];
  isAmdHybrid = builtins.elem dev.gpu.type [ "amd" "hybrid-amd" ];
  isHybrid = isNvidiaHybrid || isAmdHybrid;

  # DRM device order for wlroots-based compositors (niri uses smithay, ignores this).
  # iGPU first since it drives the display in Optimus mode.
  drmDevices =
    if isNvidiaHybrid then "/dev/dri/card2:/dev/dri/card1"
    else if isAmdHybrid then "/dev/dri/card0:/dev/dri/card1"
    else "";

  # Safe global vars for hybrid graphics:
  # - DRI_PRIME, __EGL_VENDOR_LIBRARY_FILENAMES, VK_ICD_FILENAMES are intentionally
  #   excluded — they force the compositor onto the dGPU, which breaks niri (only
  #   the iGPU can drive the display in Optimus mode). Set them per-application
  #   instead (e.g. via niri config `env` blocks or desktop file overrides).
  hybridVars = {
    WLR_DRM_DEVICES = drmDevices;
    # Default to the iGPU's VA-API/VDPAU backend so ordinary app launches
    # (e.g. browsers probing hw video decode at startup) don't wake the
    # dGPU. Get NVDEC explicitly per-command with
    # `LIBVA_DRIVER_NAME=nvidia VDPAU_DRIVER=nvidia nvidia-offload <cmd>`.
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "radeonsi";
    MANGOHUD_DLSYM = "1";
    MANGOHUD_CONFIG = "position=top-left";
  };
in
{
  config = mkIf sys.video.enable {
    environment.etc."greetd/environments".text = ''
      ${lib.optionalString config.custom.programs.hyprland.enable "Hyprland"}
      fish
      zsh
    '';

    environment = {
      sessionVariables = {
        SDL_VIDEODRIVER = "wayland,x11";

        # Hybrid graphics (NVIDIA/AMD dGPU + iGPU) - Wayland/niri
        # These are only set when a hybrid GPU is detected
      } // optionalAttrs isHybrid hybridVars;
    };
  };
}
