{ pkgs, ... }:

{
  ## Install Packages
  environment.systemPackages = with pkgs; [
    p7zip
    wine
    winetricks
  ];
}
