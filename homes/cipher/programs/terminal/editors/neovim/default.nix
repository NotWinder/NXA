{inputs, ...}: let
  system = "x86_64-linux";
in {
  home.packages = [
    inputs.nvw.packages.${system}.default
  ];

  programs.ripgrep.enable = true;
}
