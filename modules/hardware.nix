{ ... }: {
  flake.modules.nixos.hardware = {
    imports = [
      ./hardware/module.nix
    ];
  };
}
