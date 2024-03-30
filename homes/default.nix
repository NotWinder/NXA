{ config, pkgs, ... }:

{
  imports =
    [
      ./winder
    ];

  home.username = "winder";
  home.homeDirectory = "/home/winder";

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}
