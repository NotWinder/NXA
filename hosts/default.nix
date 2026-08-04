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

            # 4. Host-specific home-manager config, keyed by hostname
            # Consumes the per-user home aspect from the registry. The
            # aspect values replicate the old home/<host>/home.nix shims
            # node-for-node (cipher = direct path, others = single-wrapper).
            (singleton {
              imports = [ (registry.home.${hostname}) ];
            })

            # 5. Extra modules (sops-nix, home-manager) — LAST, exactly as before
            args.extraModules
          ]
        );

      hosts = {
        amadeus.roles = [ "graphical" "workstation" ];
        brau1589.roles = [ "graphical" "workstation" ];
        cipher.roles = [ "graphical" "workstation" ];
        heu.roles = [ "graphical" "workstation" ];
        lorian.roles = [ "headless" "server" ];
        magi.roles = [ "graphical" "workstation" ];
        salieri.roles = [ "graphical" "workstation" ];
        wired.roles = [ "graphical" "workstation" ];
      };
    in
    builtins.mapAttrs
      (hostname: cfg:
        mkNixosSystem {
          inherit withSystem;
          hostname = hostname;
          system = "x86_64-linux";
          modules = mkModulesFor hostname { extraModules = [ sops-nix hm ]; roles = cfg.roles; };
        })
      hosts;
}
