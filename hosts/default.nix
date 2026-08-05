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
        amadeus = { roles = [ "graphical" ]; home = [ "amadeus" ]; features = [ ]; system = "x86_64-linux"; };
        brau1589 = { roles = [ "graphical" ]; home = [ "brau1589" ]; features = [ "ssh" ]; system = "x86_64-linux"; };
        cipher = { roles = [ "graphical" ]; home = [ "cipher" ]; features = [ "ssh" ]; system = "x86_64-linux"; };
        heu = { roles = [ "graphical" ]; home = [ "heu" ]; features = [ ]; system = "x86_64-linux"; };
        lorian = { roles = [ "headless" "server" ]; home = [ "lorian" ]; features = [ ]; system = "x86_64-linux"; };
        magi = { roles = [ "graphical" ]; home = [ "magi" ]; features = [ ]; system = "x86_64-linux"; };
        salieri = { roles = [ "graphical" ]; home = [ "salieri" ]; features = [ ]; system = "x86_64-linux"; };
        wired = { roles = [ "graphical" ]; home = [ "wired" ]; features = [ "ssh" ]; system = "x86_64-linux"; };
      };

      mkModulesFor = hostname: { roles, home, features, ... }:
        flatten [
          # 1. Host-specific module (host.nix) — FIRST
          (singleton ./${hostname}/host.nix)

          # 2. Module trees via the nixos aspect registry
          (map (t: registry.nixos.${t}) trees)

          # 3. Roles (aspects under flake.modules.roles.*)
          (map (r: registry.roles.${r}) roles)

          # 4. Multi-class feature aspects. A feature may provide a nixos
          #    and/or a homeManager side (`or { }` makes either optional);
          #    the home side is appended to the HM aspect selection below.
          (map (f: registry.nixos.${f} or { }) features)

          # 5. Extra modules (sops-nix, home-manager) — LAST
          sops-nix
          hm

          # 6. Select this host's home-manager aspects by name.
          #    `home` names per-user entries in the `flake.modules.homeManager`
          #    registry (modules/home/users/); `features` appends the feature
          #    aspects of the same registry (e.g. ssh, gaming).
          { config.custom.usrEnv.home.aspects = home ++ features; }
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
