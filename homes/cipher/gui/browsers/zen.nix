{
  inputs',
  osConfig,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  inherit (osConfig) modules;

  prg = modules.usrEnv.programs;
in {
  config = mkIf (elem "zen" prg.browsers) {
    home.packages = [
      inputs'.zen-browser.packages.default
    ];
  };
}
