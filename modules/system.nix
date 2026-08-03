{ ... }: {
  flake.modules.nixos.system = {
    imports = [
      ./system/module.nix
    ];
  };
}
