{ ... }: {
  flake.modules.nixos.profiles = {
    imports = [
      ./profiles/module.nix
    ];
  };
}
