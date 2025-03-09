{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;

  uEnv = modules.usrEnv;
  prg = uEnv.programs;
  br = prg.browser;
in {
  config = mkIf br.brave.enable {
    home.packages = [
      pkgs.brave
    ];
  };
}
