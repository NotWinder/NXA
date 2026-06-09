{
  withSystem,
  inputs,
  ...
}: {
  flake.nixosConfigurations = let
    inherit (inputs.self) lib;
    inherit (lib) mkNixosSystem mkModuleTree' importPathOrTree;
    inherit (lib.lists) concatLists flatten singleton;

    ## flake inputs ##
    #hw = inputs.nixos-hardware.nixosModules; # hardware compat for pi4 and other quirky devices
    sops-nix = inputs.sops-nix.nixosModules.sops; # secret encryption via age
    hm = inputs.home-manager.nixosModules.home-manager; # home-manager nixos module
    # Specify root path for the modules. The concept is similar to modulesPath
    # that is found in nixpkgs, and is defined in case the modulePath changes
    # depth (i.e modules becomes nixos/modules).
    modulePath = ../modules;

    # module paths
    options = modulePath + /options;
    hardware = modulePath + /hardware;
    nix = modulePath + /nix;
    system = modulePath + /system;
    virt = modulePath + /virt;
    profiles = modulePath + /profiles;

    ## roles ##
    # Roles either provide an additional set of defaults on top of the core module
    # or override existing defaults for role-specific optimizations.
    graphical = modulePath + /roles/graphical.nix;
    headless = modulePath + /roles/headless.nix;
    server = modulePath + /roles/server.nix;
    workstation = modulePath + /roles/workstation;

    # home-manager #
    homesPath = ../home;

    # mkModulesFor generates a list of modules to be imported by any host with
    # a given hostname. Do note that this needs to be called *in* the nixosSystem
    # set, since it generates a *module list*, which is also expected by system
    # builders.
    mkModulesFor = hostname: {
      moduleTrees ? [options hardware nix system virt profiles homesPath],
      roles ? [],
      extraModules ? [],
    } @ args:
      flatten (
        concatLists [
          # Derive host specific module path from the first argument of the
          # function. Should be a string, obviously.
          (singleton ./${hostname}/host.nix)

          # Recursively import all module trees (i.e. directories with a `module.nix`)
          # for given moduleTree directories, and in addition, roles.
          (map importPathOrTree (concatLists [moduleTrees roles]))

          # And append any additional lists that don't don't conform to the moduleTree
          # API, but still need to be imported somewhat commonly.
          args.extraModules
        ]
      );
  in {
    amadeus = mkNixosSystem {
      inherit withSystem;
      hostname = "amadeus";
      system = "x86_64-linux";
      modules = mkModulesFor "amadeus" {
        roles = [graphical workstation];
        extraModules = [sops-nix hm];
      };
    };

    brau1589 = mkNixosSystem {
      inherit withSystem;
      hostname = "brau1589";
      system = "x86_64-linux";
      modules = mkModulesFor "brau1589" {
        roles = [graphical workstation];
        extraModules = [sops-nix hm];
      };
    };

    cipher = mkNixosSystem {
      inherit withSystem;
      hostname = "cipher";
      system = "x86_64-linux";
      modules = mkModulesFor "cipher" {
        roles = [graphical workstation];
        extraModules = [sops-nix hm];
      };
    };

    heu = mkNixosSystem {
      inherit withSystem;
      hostname = "heu";
      system = "x86_64-linux";
      modules = mkModulesFor "heu" {
        roles = [graphical workstation];
        extraModules = [sops-nix hm];
      };
    };

    lorian = mkNixosSystem {
      inherit withSystem;
      hostname = "lorian";
      system = "x86_64-linux";
      modules = mkModulesFor "lorian" {
        roles = [headless server];
        extraModules = [sops-nix hm];
      };
    };

    magi = mkNixosSystem {
      inherit withSystem;
      hostname = "magi";
      system = "x86_64-linux";
      modules = mkModulesFor "magi" {
        roles = [graphical workstation];
        extraModules = [sops-nix hm];
      };
    };

    salieri = mkNixosSystem {
      inherit withSystem;
      hostname = "salieri";
      system = "x86_64-linux";
      modules = mkModulesFor "salieri" {
        roles = [graphical workstation];
        extraModules = [sops-nix hm];
      };
    };

    wired = mkNixosSystem {
      inherit withSystem;
      hostname = "wired";
      system = "x86_64-linux";
      modules = mkModulesFor "wired" {
        roles = [graphical workstation];
        extraModules = [sops-nix hm];
      };
    };
  };
}
