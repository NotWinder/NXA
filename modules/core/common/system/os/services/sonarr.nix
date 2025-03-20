{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
  cfg = sys.services;
in {
  config = mkIf cfg.sonarr.enable {
    services.sonarr = {
      enable = true;
      openFirewall = true;
    };
  };
}
