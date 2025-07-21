{
  osConfig,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules;

  prg = modules.usrEnv.programs;
in {
  config = mkIf prg.gaming.mangohud.enable {
    programs.mangohud = {
      enable = true;
      settings = {
        cpu_stats = true;
        cpu_temp = true;
        gpu_stats = true;
        gpu_temp = true;
        vulkan_driver = false;
        fps = true;
        frametime = true;
        frame_timing = true;
        position = "top-left";
        engine_version = true;
        wine = true;
        no_display = true;
        toggle_hud = "Shift_R+F12";
      };
    };
  };
}
