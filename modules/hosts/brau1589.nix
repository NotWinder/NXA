{ inputs, ... }: {
  flake.modules.nixos.brau1589 = {
    imports = [
      inputs.sops-nix.nixosModules.sops
      inputs.home-manager.nixosModules.home-manager
      ../../hosts/brau1589/host.nix
    ];
  };
}
