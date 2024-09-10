{
  description = "Nixos config flake";

  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ withSystem, ... }: {
      imports = [
        { config._module.args._inputs = inputs // { inherit (inputs) self; }; }

        ## parts of the flake
        #./flake/modules # nixos and home-manager modules provided by this flake
        #./flake/pkgs # packages exposed by the flake
        ./flake/templates # flake templates

        ./flake/args.nix # args that are passed to the flake, moved away from the main file
        ./flake/deployments.nix # deploy-rs configurations for active hosts
        #./flake/fmt.nix # various formatter configurations for this flake
        #./flake/iso-images.nix # local installation media
        #./flake/pre-commit.nix # pre-commit hooks, performed before each commit inside the devShell
        ./flake/shell.nix # devShells exposed by the flake
      ];
      flake = {
        nixosConfigurations = import ./hosts { inherit inputs withSystem self; };

        packages.x86_64-linux.default =
          nixpkgs.legacyPackages.x86_64-linux.callPackage ./homes/winder/program/graphical/desktop/tools/bar/ags/config { inherit inputs; };
      };
      systems = [ "x86_64-linux" ];
    });

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    astal = {
      url = "github:Aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    matugen = {
      url = "github:InioX/matugen";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nil_ls = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stm = {
      url = "github:Aylur/stm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
