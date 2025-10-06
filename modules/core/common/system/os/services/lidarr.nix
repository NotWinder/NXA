{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
  cfg = sys.services;
in {
  config = mkIf cfg.lidarr.enable {
    users.users.lidarr.extraGroups = ["media"];
    services.lidarr = {
      enable = true;
      openFirewall = true;
    };
  };
}
