# Multi-class `gaming` feature (Phase 5 item 1): selecting
# `features = [ "gaming" ]` on a host flips the `custom.usrEnv.programs.gaming`
# umbrella option (drives the system gaming tree) and composes the
# homeManager gaming aspect (internally gated on the same umbrella). The
# feature selection replaces the old `custom.profiles.gaming.enable` option.
{ ... }:
{
  flake.modules.nixos.gaming = {
    config = {
      custom.usrEnv.programs.gaming.enable = true;
    };
  };

  flake.modules.homeManager.gaming = {
    imports = [ ./_lib/home/gaming ];
  };
}
