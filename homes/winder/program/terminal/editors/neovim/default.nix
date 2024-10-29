{inputs, ...}: let
  system = "x86_64-linux";
in {
  programs.neovim = inputs.nvw.lib.mkHomeManager {inherit system;};
  programs.ripgrep.enable = true;
}
