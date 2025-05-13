{osConfig, ...}: let
  inherit (osConfig) modules;

  # theming
  inherit (modules.style) pointerCursor;
in {
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      # set cursor for HL itself
      "hyprctl setcursor ${pointerCursor.name} ${toString pointerCursor.size}"
      "systemctl --user enable --now hyprpaper.service"
      #"systemctl --user enable --now hyprlock.service"
      "hyprlock"
      "hyprpaper-timer"
      "waybar"
      "nm-applet"
    ];
  };
}
