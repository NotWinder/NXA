{ inputs, ... }: {
  flake.modules.nixos.cipher = {
    imports = [
      inputs.sops-nix.nixosModules.sops
      inputs.home-manager.nixosModules.home-manager
      ../../hosts/cipher/host.nix
    ];
  };
}
