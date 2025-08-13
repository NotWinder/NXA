{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;

  prg = modules.usrEnv.programs;
in {
  config = mkIf prg.browsers.librewolf.enable {
    programs.librewolf = {
      enable = true;
      package = pkgs.librewolf;
    };
  };
}
