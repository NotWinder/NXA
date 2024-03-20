{ pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      ./modules/all.nix
    ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  ##  Set your time zone.
  time.timeZone = "Asia/Tehran";
  ## Enable sound.
  sound.enable = true;
  ## Home-manager
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "winder" = import ../user/home.nix;
    };
  };
  # Define a user account.
  users.users.winder = {
    isNormalUser = true;
    extraGroups = [ "wheel" "adbusers" ];
  };

  ## System
  system = {
    stateVersion = "unstable";
  };
}
