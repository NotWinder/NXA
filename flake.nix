{
  description = "Nixos config flake";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";

    ags.url = "github:Aylur/ags";
    astal.url = "github:Aylur/astal";
    stm.url = "github:Aylur/stm";
    matugen.url = "github:InioX/matugen";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages.x86_64-linux.default =
        nixpkgs.legacyPackages.x86_64-linux.callPackage ./user/modules/ags { inherit inputs; };

      devShells.x86_64-linux = {
        python = pkgs.mkShell {
          nativeBuildInputs = with pkgs.python312Packages;
            [
              django
              openpyxl
              pandas
              jdatetime
              pillow
            ];

          shellHook = ''
            echo "welcome to the python shell"
          '';
        };
      };

      nixosConfigurations = {
        winder = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            asztal = self.packages.x86_64-linux.default;
          };
          modules = [
            ./nixos/pc/configuration.nix
          ];
        };

        winder-laptop = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            asztal = self.packages.x86_64-linux.default;
          };
          modules = [
            ./nixos/laptop/configuration.nix
          ];
        };
      };
    };
}
