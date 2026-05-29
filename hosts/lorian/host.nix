{
  imports = [
    ./fs.nix
    ./modules
  ];

  config = {
    system.stateVersion = "23.11";
  };
}
