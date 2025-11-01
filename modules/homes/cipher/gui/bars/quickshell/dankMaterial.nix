{
  inputs,
  inputs',
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (builtins) elem;
  inherit (lib) mkIf optionals;
  inherit (config) modules;

  env = modules.usrEnv;
  prg = env.programs;

  winpaper = inputs'.winpaper.packages;
in {
  config.hm = {
    imports = [
      inputs.dankMaterialShell.homeModules.dankMaterialShell.default
    ];
    programs.dankMaterialShell = mkIf (elem "quickshell/dms" prg.bar && env.desktop != "none") {
      enable = true;
    };
  };
}
