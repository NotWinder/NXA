{config, pkgs, lib, osConfig, ...}:
let
  inherit (lib) mkIf;
in
{
  imports = [
    ./config.nix
    ./tools/swaylock.nix
    ./tools/swaybg.nix
  ];
  config = mkIf osConfig.custom.programs.sway.enable {
    wayland.windowManager.sway = {
      enable = true;
      package = pkgs.swayfx;
    };
  };
}
