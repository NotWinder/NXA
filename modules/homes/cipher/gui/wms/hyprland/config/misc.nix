{
  config,
  lib,
  ...
}: let
  inherit (config) modules;
  inherit (lib) mkIf;
  env = modules.usrEnv;
in {
  config.hm = mkIf (env.desktop == "Hyprland") {
    wayland.windowManager.hyprland.settings = {
      cursor = {
        hotspot_padding = 1;
      };
      misc = {
        # Disable redundant renders
        disable_hyprland_logo = true; # wallpaper covers it anyway
        disable_splash_rendering = true; # "

        # Window swallowing
        # (i.e. children window causes parent to be hidden)
        enable_swallow = true; # Enable window swallowing
        swallow_regex = "foot|thunar|nemo|wezterm"; # Windows for which swallowing is applied

        # dpms
        mouse_move_enables_dpms = true; # Enable DPMS on mouse/touchpad action
        key_press_enables_dpms = true; # Enable DPMS on keyboard action
      };
    };
  };
}
