{ pkgs, inputs, ... }:

{
  ## Install Packages
  environment.systemPackages = with pkgs; [
    gopls # go ls
    nil # nix ls
    rust-analyzer # rust ls
    nodePackages.typescript-language-server # tsserver ls
  ];
}
