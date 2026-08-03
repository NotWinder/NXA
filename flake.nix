{
  description = "NXA (Nix Automata)";

  inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    systems.url = "github:nix-systems/default";

    import-tree.url = "github:denful/import-tree";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #caelestia-shell = {
    #  url = "github:caelestia-dots/shell";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs = {
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprpicker.url = "github:hyprwm/hyprpicker";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Personal collection of packages and modules
    # that are too unstable or too personal for nyxexprs.
    nyxexprs = {
      url = "github:NotAShelf/nyxexprs";
    };

    # Impermanence
    # doesn't offer much above properly used symlinks
    # but it *is* convenient
    impermanence.url = "github:nix-community/impermanence";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    winpaper = {
      url = "github:notwinder/winpaper";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = inputs @ { flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];

      imports = [
        # Auto-load the coarse aspect files at the top of `modules/` into the
        # flake-parts module space (the `flake.modules.nixos.<name>` registry).
        # The legacy NixOS module trees are excluded here: they are consumed by
        # hosts via `mkModulesFor` until Phase 2+ wires them through the registry.
        (((inputs.import-tree).filter (path:
          builtins.match ".*/(options|system|hardware|nix|virt|profiles|roles)/.*" path == null)
        )
          ./modules)
        ./hosts
        ./lib
      ];
    };
}
