{
  description = "Nixos config flake";

  outputs = {
    nixpkgs,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;}
    ({...}: {
      systems = import inputs.systems;

      imports = [
        ./parts # Parts of the flake that are used to construct the final flake.
        ./hosts # Entrypoint for host configurations of my systems.
      ];

      flake = {
        packages.x86_64-linux.default =
          nixpkgs.legacyPackages.x86_64-linux.callPackage ./homes/winder/program/graphical/tools/bar/ags/config {inherit inputs;};
      };
    });

  inputs = {
    systems.url = "github:nix-systems/default-linux";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-unstable-small"; # moves faster, has less packages

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    matugen.url = "github:InioX/matugen?ref=v2.2.0";
    ags.url = "github:Aylur/ags";
    astal.url = "github:Aylur/astal";

    stm = {
      url = "github:Aylur/stm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs = {
        hyprlang.follows = "hyprland/hyprlang";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    hyprpicker.url = "github:hyprwm/hyprpicker";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";

    nvw.url = "github:notwinder/nvw";
  };
}
