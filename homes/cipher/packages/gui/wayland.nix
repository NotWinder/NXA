{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules meta;

  sys = modules.system;
  prg = sys.programs;
in {
  config = mkIf (prg.gui.enable && (sys.video.enable && meta.isWayland)) {
    home.packages = with pkgs; [
      wlogout # Wayland based logout menu
      swappy # Wayland native snapshot editing tool, inspired by Snappy on macOS
    ];
  };
}
