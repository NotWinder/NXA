{ config
, pkgs
, lib
, ...
}:
let
  inherit (lib) mkIf;
in
{
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
