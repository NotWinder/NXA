{
  inputs',
  lib,
  config,
  ...
}: let
  inherit (builtins) elem;
  inherit (lib) mkIf;
  inherit (config) modules;
  env = modules.usrEnv;
  prg = env.programs;
in {
  imports = [
    ./caelestia.nix
    ./dankMaterial.nix
    ./noctalia.nix
  ];
  config.hm = mkIf (elem "quickshell" prg.bar && env.desktop != "none") {
    #home.packages = [
    #  inputs'.quickshell.packages.default
    #];
  };
}
