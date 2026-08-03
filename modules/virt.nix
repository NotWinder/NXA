{ ... }: {
  flake.modules.nixos.virt = {
    imports = [
      ./virt/module.nix
    ];
  };
}
