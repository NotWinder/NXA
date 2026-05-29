{ config
, lib
, ...
}:
let
  inherit (lib) mkIf;

  sys = config.custom.system;
  cfg = sys.services;
in
{
  config = mkIf cfg.sonarr.enable {
    users.users.sonarr.extraGroups = [ "media" ];
    services.sonarr = {
      enable = true;
      openFirewall = true;
    };
  };
}
