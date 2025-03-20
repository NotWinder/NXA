{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
  cfg = sys.services;
in {
  config = mkIf cfg.xray.enable {
    services.xray = {
      enable = true;
      settingsFile = "/etc/xray/config.json";
    };
  };
}
