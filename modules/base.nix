{ ... }: {
  flake.modules.nixos.base = {
    imports = [
      ./options/module.nix
    ];
  };
}
