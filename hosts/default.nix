{ withSystem
, inputs
, config
, ...
}: {
  flake.nixosConfigurations =
    let
      inherit (inputs.self) lib;
      inherit (lib) mkNixosSystem mkModuleTree' importPathOrTree;
      inherit (lib.lists) concatLists flatten singleton;

      ## flake inputs ##
      sops-nix = inputs.sops-nix.nixosModules.sops; # secret encryption via age
      hm = inputs.home-manager.nixosModules.home-manager; # home-manager nixos module

      # module paths
      modulePath = ../modules;
      options = modulePath + /options;
      hardware = modulePath + /hardware;
      nix = modulePath + /nix;
      system = modulePath + /system;
      virt = modulePath + /virt;
      profiles = modulePath + /profiles;

      ## roles (now aspects under flake.modules.roles.*) ##
      # graphical, headless, server are flat aspect files (imported directly)
      graphical = modulePath + /roles/graphical.nix;
      headless = modulePath + /roles/headless.nix;
      server = modulePath + /roles/server.nix;
      # workstation must point to the directory containing module.nix
      # (preserves importPathOrTree behavior: returns [ workstation/module.nix ])
      workstation = modulePath + /_lib/roles/workstation/system;

      # home-manager #
      homesPath = ../home;

      # Aspect registry for hosts and roles only.
      # Trees (options, hardware, nix, system, virt, profiles) still use
      # importPathOrTree directly to preserve exact module list shape.
      registry = config.flake.modules;

      # mkModulesFor generates a list of modules to be imported by any host.
      # This replicates the EXACT pre-Phase-2 module order to preserve drvPaths.
      mkModulesFor = hostname: { moduleTrees ? [ options hardware nix system virt profiles homesPath ]
                               , roles ? [ ]
                               , extraModules ? [ ]
                               ,
                               } @ args:
        let
          # Map role names to their module VALUES from registry
          roleValues = map (r: registry.roles.${r}) args.roles;
        in
        flatten (
          concatLists [
            # 1. Host-specific module (host.nix) — FIRST, exactly as before
            (singleton ./${hostname}/host.nix)

            # 2. Recursively import all module trees (options, hardware, nix, system, virt, profiles, homesPath)
            (map importPathOrTree moduleTrees)

            # 3. Roles (registry values, producing same config)
            roleValues

            # 4. Reserved (home-manager wiring moved into ../home/module.nix,
            #    Phase 3a: home-manager.users.<mainUser>.imports now composes
            #    the named `flake.modules.homeManager` aspects)

            # 5. Extra modules (sops-nix, home-manager) — LAST, exactly as before
            args.extraModules
          ]
        );

      hosts = {
        amadeus.roles = [ "graphical" "workstation" ];
        amadeus.home = [ "amadeus" ];
        brau1589.roles = [ "graphical" "workstation" ];
        brau1589.home = [ "brau1589" ];
        cipher.roles = [ "graphical" "workstation" ];
        cipher.home = [ "cipher" ];
        heu.roles = [ "graphical" "workstation" ];
        heu.home = [ "heu" ];
        lorian.roles = [ "headless" "server" ];
        lorian.home = [ "lorian" ];
        magi.roles = [ "graphical" "workstation" ];
        magi.home = [ "magi" ];
        salieri.roles = [ "graphical" "workstation" ];
        salieri.home = [ "salieri" ];
        wired.roles = [ "graphical" "workstation" ];
        wired.home = [ "wired" ];
      };
    in
    builtins.mapAttrs
      (hostname: cfg:
        mkNixosSystem {
          inherit withSystem;
          hostname = hostname;
          system = "x86_64-linux";
          modules = mkModulesFor hostname {
            extraModules = [
              sops-nix
              hm
              # Phase 3d: select this host's home-manager aspects by name.
              # `home` names entries in the `flake.modules.homeManager`
              # registry (per-user aspects under modules/home/users/).
              { config.custom.usrEnv.home.aspects = cfg.home; }
            ];
            roles = cfg.roles;
          };
        })
      hosts;
}
