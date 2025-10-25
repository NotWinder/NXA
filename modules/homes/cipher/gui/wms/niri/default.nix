{
  config,
  inputs',
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) filter map toString;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.modules) mkIf;
  inherit (lib.strings) hasSuffix;
  inherit (config) modules;

  env = modules.usrEnv;
in {
  config = mkIf (env.desktop == "Hyprland") {
    hm.home.packages = with pkgs; [
      xwayland-satellite
    ];

    programs.niri = {
      enable = true;
      #package = inputs'.niri.packages.default;
    };
  };
}
