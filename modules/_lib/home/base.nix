{ config, ... }:
let
  sys = config.custom.system;
in
{
  config.hm = {
    home = {
      username = "${sys.mainUser}";
      homeDirectory = "${sys.homePath}";
      extraOutputsToInstall = [ "doc" "devdoc" ];

      stateVersion = "23.11";
    };

    systemd.user.startServices = "sd-switch";
  };
}
