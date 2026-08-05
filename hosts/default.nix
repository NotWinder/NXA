{ withSystem
, inputs
, config
, ...
}: {
  flake.nixosConfigurations =
    let
      inherit (inputs.self) lib;
      inherit (lib) mkNixosSystem;
      inherit (lib.lists) flatten singleton;

      ## flake inputs ##
      sops-nix = inputs.sops-nix.nixosModules.sops; # secret encryption via age
      hm = inputs.home-manager.nixosModules.home-manager; # home-manager nixos module

      # Aspect registry: nixos trees (base = options), roles, homeManager aspects.
      registry = config.flake.modules;

      # Module trees in legacy import order. Each aspect imports its tree's
      # top-level module.nix, which transitively imports the full tree.
      trees = [ "base" "hardware" "nix" "system" "virt" "profiles" ];

      hosts = {
        amadeus = { roles = [ "graphical" ]; home = [ "amadeus" ]; system = "x86_64-linux"; };
        brau1589 = { roles = [ "graphical" ]; home = [ "brau1589" ]; system = "x86_64-linux"; };
        cipher = { roles = [ "graphical" ]; home = [ "cipher" ]; system = "x86_64-linux"; };
        heu = { roles = [ "graphical" ]; home = [ "heu" ]; system = "x86_64-linux"; };
        lorian = { roles = [ "headless" "server" ]; home = [ "lorian" ]; system = "x86_64-linux"; };
        magi = { roles = [ "graphical" ]; home = [ "magi" ]; system = "x86_64-linux"; };
        salieri = { roles = [ "graphical" ]; home = [ "salieri" ]; system = "x86_64-linux"; };
        wired = { roles = [ "graphical" ]; home = [ "wired" ]; system = "x86_64-linux"; };
      };

      mkModulesFor = hostname: { roles, home, ... }:
        flatten [
          # 1. Host-specific module (host.nix) — FIRST
          (singleton ./${hostname}/host.nix)

          # 2. Module trees via the nixos aspect registry
          (map (t: registry.nixos.${t}) trees)

          # 3. Roles (aspects under flake.modules.roles.*)
          (map (r: registry.roles.${r}) roles)

          # 4. Extra modules (sops-nix, home-manager) — LAST
          sops-nix
          hm

          # 5. Select this host's home-manager aspects by name.
          #    `home` names entries in the `flake.modules.homeManager`
          #    registry (per-user aspects under modules/home/users/).
          { config.custom.usrEnv.home.aspects = home; }
        ];
    in
    builtins.mapAttrs
      (hostname: cfg:
        mkNixosSystem {
          inherit withSystem;
          hostname = hostname;
          system = cfg.system;
          modules = mkModulesFor hostname cfg;
        })
      hosts;
}
