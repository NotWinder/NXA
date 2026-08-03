{ inputs, ... }: {
  flake.modules.nixos.magi = {
    imports = [
      inputs.sops-nix.nixosModules.sops
      inputs.home-manager.nixosModules.home-manager
      ../../hosts/magi/host.nix
    ];
  };
}
