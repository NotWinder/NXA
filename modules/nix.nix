{ ... }: {
  flake.modules.nixos.nix = {
    imports = [
      ./nix/module.nix
    ];
  };
}
