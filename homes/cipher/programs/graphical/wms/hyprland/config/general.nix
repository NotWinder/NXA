{osConfig, ...}: let
  inherit (osConfig) modules;

  # theming
  inherit (modules.style) colorScheme;
  inherit (colorScheme) colors;
in {
  wayland.windowManager.hyprland.settings = {
    general = {
      # gaps
      gaps_in = 4;
      gaps_out = 8;

      # border thiccness
      border_size = 2;

      # active border color
      "col.active_border" = "0xff${colors.base07}";
    };
  };
}
