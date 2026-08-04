{ ... }: {
  config.hm.imports = [
    ./global.nix
    ./gtk.nix
    ./qt.nix
  ];
}
