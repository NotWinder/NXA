# Closure-captured home-manager aspect for the Zen browser (Phase 3c step 4).
#
# This module is loaded into the flake-parts module space (auto-imported under
# `modules/home/`). Its `inputs` argument comes from flake-parts' top-level
# specialArgs, and the deferredModule below closes over it — so no
# `extraSpecialArgs` plumbing is needed in the home-manager+NixOS wiring.
{ inputs, ... }: {
  flake.modules.homeManager.zen = { lib, osConfig, ... }:
    let
      inherit (builtins) elem;
      inherit (lib) mkIf;
      prg = osConfig.custom.usrEnv.programs;
    in
    {
      imports = [ inputs.zen-browser.homeModules.beta ];
      config.programs.zen-browser.enable = mkIf (elem "zen-beta" prg.browsers) true;
    };
}
