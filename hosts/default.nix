{ withSystem
, inputs
, config
, ...
}: {
  flake.nixosConfigurations =
    let
      inherit (inputs.self) lib;
      inherit (lib) mkNixosSystem;
      inherit (lib.lists) flatten;

      # home-manager #
      homesPath = ../home;

      # Aspect registry: host and role aspects register themselves under
      # flake.modules.* (see modules/hosts/, modules/roles/). The coarse
      # system aspects wrap the legacy NixOS module trees (modules/options,
      # modules/system, ...) until those trees migrate in later phases.
      registry = config.flake.modules;

      commonAspects = [ "base" "system" "hardware" "nix" "virt" "profiles" ];

      # mkModulesFor assembles the module list for a host from registry aspects.
      # Do note that this needs to be called *in* the nixosSystem set, since it
      # generates a *module list*, which is also expected by system builders.
      mkModulesFor = hostname: { roles, ... }:
        flatten [
          (map (n: registry.nixos.${n}) commonAspects)
          (map (r: registry.roles.${r}) roles)
          registry.nixos.${hostname}

          # Host-specific home-manager config, keyed by hostname. The HM
          # integration module (home/module.nix) is the only module.nix in
          # home/; the per-user config is added separately below.
          [ ../home/module.nix ]
          { imports = [ (homesPath + "/${hostname}/home.nix") ]; }
        ];

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
          modules = mkModulesFor hostname cfg;
        })
      hosts;
}
