{ lib, ... }:
let
  inherit (lib.options) mkEnableOption;
in
{
  # Window manager / bar program options are declared here (moved out of the
  # home-manager module tree during the dendritic migration, Phase 3a), because
  # homeManager-class aspects must not declare NixOS options. The NixOS-side
  # wms configuration that reacts to these lives in the system tree instead.
  options.custom.programs = {
    sway = {
      enable = mkEnableOption "sway window manager";
    };

    niri = {
      enable = mkEnableOption "Enable Niri as a window manager";
    };

    hyprland = {
      enable = mkEnableOption "Hyprland window manager";
    };

    hyprlock = {
      enable = mkEnableOption "Hyprlock, screen locker for Hyprland";
    };

    hyprpaper = {
      enable = mkEnableOption "Hyprpaper wallpaper manager";
    };

    dms = {
      enable = mkEnableOption "Enable DankMaterialShell";
    };
  };
}
