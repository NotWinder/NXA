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
    LIBVA_DRIVER_NAME = if isNvidiaHybrid then "nvidia" else "radeonsi";
    VDPAU_DRIVER = if isNvidiaHybrid then "nvidia" else "radeonsi";
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
