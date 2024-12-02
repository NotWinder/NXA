{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;

  sys = modules.system;
  prg = sys.programs;
in {
  config = mkIf (prg.gui.enable && sys.printing."3d".enable) {
    home.packages = with pkgs; [
      freecad # General purpose Open Source 3D CAD/MCAD/CAx/CAE/PLM modeler
      prusa-slicer # G-code generator for 3D printer
    ];
  };
}
