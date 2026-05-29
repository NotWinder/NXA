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
  config = mkIf cfg.prowlarr.enable {
    services.prowlarr = {
      enable = true;
      openFirewall = true;
    };
  };
}
