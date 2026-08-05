{ inputs, ... }: {
  flake.modules.nixos.lorian = {
    imports = [
      inputs.sops-nix.nixosModules.sops
      inputs.home-manager.nixosModules.home-manager
      ../../hosts/lorian/host.nix
    ];
  };
}
