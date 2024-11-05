{inputs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./system.nix
    inputs.home-manager.nixosModules.home-manager
  ];
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  ##  Set your time zone.
  time.timeZone = "Asia/Tehran";
}
