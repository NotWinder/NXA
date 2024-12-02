{
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;

  sys = modules.system;
  prg = sys.programs;
in {
  config = mkIf prg.obs.enable {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-gstreamer # OBS Studio source, encoder and video filter plugin to use GStreamer elements/pipelines in OBS Studio
        obs-pipewire-audio-capture # Audio device and application capture for OBS Studio using PipeWire
        obs-vkcapture # OBS Linux Vulkan/OpenGL game capture
        wlrobs # Obs-studio plugin that allows you to screen capture on wlroots based wayland compositors
      ];
    };
  };
}
