{
  # Explicitly import "parts" of a flake to compose it modularly. This
  # allows me to import each part to construct the "final flake" instead
  # of declaring everything from a single, convoluted file.
  # By convention, things that would usually go to flake.nix should
  # have its own file in the `parts/` directory.
  imports = [
    ./lib # Extensible extended library built on top of `nixpkgs.lib`
  ];
}
