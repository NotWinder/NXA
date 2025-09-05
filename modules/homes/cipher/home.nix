{config, ...}: let
  sys = config.modules.system;
in {
  imports = [
    ./cli
    ./gui
    ./misc
    ./themes
  ];

  config.hm = {
    home = {
      username = "${sys.mainUser}";
      homeDirectory = "${sys.homePath}";
      extraOutputsToInstall = ["doc" "devdoc"];

      stateVersion = "23.11";
    };

    systemd.user.startServices = "sd-switch";
  };
}
