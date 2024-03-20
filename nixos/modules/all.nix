{
  imports =
    [
      ./bootloader-uefi.nix
      ./fonts.nix
      ./hyprland.nix
      ./install-pkgs/default.nix
      ./install-pkgs/dev-pkgs.nix
      ./networking.nix
      ./nvidia.nix
      ./polkit.nix
      ./services.nix
      ./thunar.nix
      ./unfree.nix
      ./xserver-and-display-manager.nix
      ./zfs.nix
    ];
}
