{
  inputs',
  osConfig,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;

  uEnv = modules.usrEnv;
  prg = uEnv.programs;
  br = prg.browser;
in {
  config = mkIf br.zen.enable {
    home.packages = [
      inputs'.zenf.packages.default
    ];
  };
}
