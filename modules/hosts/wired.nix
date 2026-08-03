{ inputs, ... }: {
  flake.modules.nixos.wired = {
    imports = [
      inputs.sops-nix.nixosModules.sops
      inputs.home-manager.nixosModules.home-manager
      ../../hosts/wired/host.nix
    ];
  };
}
