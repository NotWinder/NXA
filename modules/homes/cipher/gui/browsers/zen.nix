{
  inputs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  inherit (config) modules;

  prg = modules.usrEnv.programs;
in {
  config.hm = {
    imports = [inputs.zen-browser.homeModules.beta];
    programs.zen-browser.enable = mkIf (elem "zen" prg.browsers) true;
  };
}
