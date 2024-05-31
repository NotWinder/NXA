{ pkgs, inputs, ... }:

{
  ## Install Packages
  environment.systemPackages = with pkgs; [
    nodePackages.typescript-language-server
    nil
    lua-language-server
    gopls
    rust-analyzer
  ];
}
