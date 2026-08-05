{ inputs, ... }: {
  flake.modules.nixos.amadeus = {
    imports = [
      inputs.sops-nix.nixosModules.sops
      inputs.home-manager.nixosModules.home-manager
      ../../hosts/amadeus/host.nix
    ];
  };
}
