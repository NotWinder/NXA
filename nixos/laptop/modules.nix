{
  imports =
    [
      ../modules/audio.nix
      ../modules/bootloader/legacy.nix
      ../modules/fonts.nix
      ../modules/networking.nix
      ../modules/packages/development.nix
      ../modules/packages/others.nix
      ../modules/services.nix
      ../modules/wm/sddm.nix
      ../modules/wm/hyprland-laptop.nix
      ../modules/wm/polkit.nix
      ../modules/wm/thunar.nix
      ../modules/wm/xserver.nix
    ];
}
