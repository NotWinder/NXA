{ config
, inputs
, pkgs
, lib
, ...
}:
let
  inherit (lib.modules) mkIf;
in
{
  imports = [
    inputs.niri.nixosModules.niri
  ];
  config = mkIf config.custom.programs.niri.enable {
    nixpkgs.overlays = [ inputs.niri.overlays.niri ];
    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };
  };
}