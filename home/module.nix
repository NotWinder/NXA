{ config
, self
, lib
, ...
}:
let
  inherit (lib.modules) mkIf;
  inherit (config) custom;

  sys = custom.system;
  env = custom.usrEnv;

  # Phase 3a wiring: home-manager aspects are now first-class modules in the
  # `flake.modules.homeManager` registry, consumed by name below instead of
  # through the old `config.hm` alias.
  registry = self.modules.homeManager;
  homeAspects = env.home.aspects;
in
{
  home-manager = mkIf env.useHomeManager {
    # tell home-manager to be as verbose as possible
    verbose = true;

    # use the system configuration’s pkgs argument
    # this ensures parity between nixos' pkgs and hm's pkgs
    useGlobalPkgs = true;

    # enable the usage user packages through
    # the users.users.<name>.packages option
    useUserPackages = true;

    # move existing files to the .old suffix rather than failing
    # with a very long error message about it
    backupFileExtension = "hm.old";

    # Phase 3a wiring: compose the main user's home-manager config from the
    # named homeManager-class aspects in the registry, in declared order.
    # Flake closure capture (Phase 3c step 4) now happens in the aspect
    # definitions under `modules/home/`; no `extraSpecialArgs` is needed.
    users.${sys.mainUser}.imports = map (name: registry.${name}) homeAspects;
  };
}
