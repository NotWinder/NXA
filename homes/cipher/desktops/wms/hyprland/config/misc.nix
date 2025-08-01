{
  osConfig,
  lib,
  ...
}: let
  inherit (osConfig) modules;
  inherit (lib) mkIf;
  env = modules.usrEnv;
in {
  config = mkIf env.desktops.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
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
