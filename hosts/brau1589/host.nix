{ lib, ... }: {
  imports = [
    ./fs.nix
    ./modules
  ];

  config = {
    system.stateVersion = "25.05";
    stylix.enable = lib.mkForce false;
  };
}
