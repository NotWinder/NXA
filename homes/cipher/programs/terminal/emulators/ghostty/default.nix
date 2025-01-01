{
  inputs,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

  prg = osConfig.modules.system.programs.terminals;
in {
  config = mkIf prg.ghostty.enable {
    home.packages = [
      inputs.ghostty.packages.x86_64-linux.default
    ];
  };
}
