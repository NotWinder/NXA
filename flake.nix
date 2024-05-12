{
  description = "Nixos config flake";

  outputs = { self, nixpkgs, flake-parts, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    flake-parts.lib.mkFlake { inherit inputs; } ({ withSystem, ... }: {
      systems = [ "x86_64-linux" ];
      imports = [
        { config._module.args._inputs = inputs // { inherit (inputs) self; }; }

        ## parts of the flake
        ./flake/modules # nixos and home-manager modules provided by this flake
        ./flake/pkgs # packages exposed by the flake
        ./flake/templates # flake templates

        ./flake/args.nix # args that are passed to the flake, moved away from the main file
        ./flake/deployments.nix # deploy-rs configurations for active hosts
        #./flake/fmt.nix # various formatter configurations for this flake
        #./flake/iso-images.nix # local installation media
        #./flake/pre-commit.nix # pre-commit hooks, performed before each commit inside the devShell
        ./flake/shell.nix # devShells exposed by the flake
      ];
      flake = {
        formatter = {
          x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
        };

        packages.x86_64-linux.default =
          nixpkgs.legacyPackages.x86_64-linux.callPackage ./homes/winder/program/graphical/desktop/tools/bar/ags/config { inherit inputs; };
        # entry-point for nixos configurations
        nixosConfigurations = import ./hosts { inherit inputs withSystem self; };
      };
    });

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Powered by
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    hyprpicker.url = "github:hyprwm/hyprpicker";

    matugen.url = "github:InioX/matugen";
    ags.url = "github:Aylur/ags";
    astal.url = "github:Aylur/astal";
    stm.url = "github:Aylur/stm";

  };
}
