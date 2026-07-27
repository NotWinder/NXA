{
  imports = [
    ./fs.nix
    ./modules
  ];

  config = {
    system.stateVersion = "25.05";
    boot.binfmt.emulatedSystems = [ "i686-linux" ];
  };
}
