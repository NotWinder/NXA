{
  imports = [
    ./program
  ];

  config = {
    home = {
      username = "winder";
      homeDirectory = "/home/winder";
      stateVersion = "23.11";
    };
    programs.home-manager.enable = true;
  };
}
