{
  imports = [
    ./fs.nix
    ./modules
  ];

  config = {
    system.stateVersion = "25.05";
  };
}
