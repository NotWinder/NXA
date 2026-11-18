{ config, lib, ... }:
with lib; let
  cfg = config.custom.system.networking.netbird;
in
{
  config = mkIf cfg.enable {
    services.netbird.enable = true;
  };
}
