{ inputs, ... }: {
  flake.modules.nixos.salieri = {
    imports = [
      inputs.sops-nix.nixosModules.sops
      inputs.home-manager.nixosModules.home-manager
      ../../hosts/salieri/host.nix
    ];
  };
}
