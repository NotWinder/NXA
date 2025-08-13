{
  inputs',
  osConfig,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;

  prg = modules.usrEnv.programs;
in {
  config = mkIf prg.browsers.zen.enable {
    home.packages = [
      inputs'.zen-browser.packages.default
    ];
  };
}
