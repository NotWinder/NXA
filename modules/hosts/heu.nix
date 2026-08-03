{ inputs, ... }: {
  flake.modules.nixos.heu = {
    imports = [
      inputs.sops-nix.nixosModules.sops
      inputs.home-manager.nixosModules.home-manager
      ../../hosts/heu/host.nix
    ];
  };
}
