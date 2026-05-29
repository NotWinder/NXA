{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
in {
  options.custom.programs.sway = {
    enable = lib.mkEnableOption "sway window manager";
  };
  imports = [
    ./config.nix
    ./tools/swaylock.nix
    ./tools/swaybg.nix
  ];
  config.hm = mkIf config.custom.programs.sway.enable {
    wayland.windowManager.sway = {
      enable = true;
      package = pkgs.swayfx;
    };
  };
}
