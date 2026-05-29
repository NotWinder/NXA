{ inputs
, config
, lib
, ...
}:
let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  inherit (config) custom;

  prg = custom.usrEnv.programs;
in
{
  config.hm = {
    imports = [ inputs.zen-browser.homeModules.beta ];
    programs.zen-browser.enable = mkIf (elem "zen-beta" prg.browsers) true;
  };
}
