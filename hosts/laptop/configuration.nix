{ pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./system.nix
    ];
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  ##  Set your time zone.
  time.timeZone = "Asia/Tehran";
}
