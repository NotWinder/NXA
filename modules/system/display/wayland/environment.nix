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

  # Determine DRM devices for hybrid graphics
  drmDevices =
    if isNvidiaHybrid then "/dev/dri/card1:/dev/dri/card2"
    else if isAmdHybrid then "/dev/dri/card0:/dev/dri/card1"
    else "";

  hybridVars = {
    WLR_DRM_DEVICES = drmDevices;
    DRI_PRIME = "1";
    LIBVA_DRIVER_NAME = if isNvidiaHybrid then "nvidia" else "radeonsi";
    VDPAU_DRIVER = if isNvidiaHybrid then "nvidia" else "radeonsi";
    __GLX_VENDOR_LIBRARY_NAME = if isNvidiaHybrid then "nvidia" else "";
    __EGL_VENDOR_LIBRARY_FILENAMES =
      if isNvidiaHybrid then
        "/run/opengl-driver/share/egl/egl_external_platform.d/15_nvidia.json"
      else "";
    VK_ICD_FILENAMES =
      if isNvidiaHybrid then
        "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json:/run/opengl-driver-32/share/vulkan/icd.d/nvidia_icd.i686.json"
      else if isAmdHybrid then
        "/usr/share/vulkan/icd.d/radeon_icd.x86_64.json:/usr/share/vulkan/icd.d/radeon_icd.i686.json"
      else "";
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
        #_JAVA_AWT_WM_NONEREPARENTING = "1";
        #NIXOS_OZONE_WL = "1";
        #GDK_BACKEND = "wayland,x11";
        #ANKI_WAYLAND = "1";
        #MOZ_ENABLE_WAYLAND = "1";
        #XDG_SESSION_TYPE = "wayland";
        #SDL_VIDEODRIVER = "wayland";
        SDL_VIDEODRIVER = "wayland,x11";
        #CLUTTER_BACKEND = "wayland";
        # XWAYLAND_NO_GLAMOR = "1";  # Disabled for hybrid graphics - causes tearing

        # Hybrid graphics (NVIDIA/AMD dGPU + iGPU) - Wayland/niri
        # These are only set when a hybrid GPU is detected
      } // optionalAttrs isHybrid hybridVars;
    };
  };
}
