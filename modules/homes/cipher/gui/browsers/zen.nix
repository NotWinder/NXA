{
  inputs',
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  inherit (config) modules;

  prg = modules.usrEnv.programs;
in {
  config.hm = mkIf (elem "zen" prg.browsers) {
    home.packages = [
      inputs'.zen-browser.packages.default
    ];
  };
}
