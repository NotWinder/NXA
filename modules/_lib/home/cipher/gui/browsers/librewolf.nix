{pkgs, lib, config, osConfig, ...}:
let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  inherit (osConfig) custom;

  prg = custom.usrEnv.programs;
in
{
  config = mkIf (elem "librewolf" prg.browsers) {
    programs.librewolf = {
      enable = true;
      package = pkgs.librewolf;
    };
  };
}
