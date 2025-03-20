{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
  cfg = sys.services;
in {
  config = mkIf cfg.radarr.enable {
    services.radarr = {
      enable = true;
      openFirewall = true;
    };
  };
}
