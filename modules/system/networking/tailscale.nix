{ config, lib, pkgs, ... }:
with lib; let
  sys = config.custom.system;
  cfg = sys.networking.tailscale;
in
{
  config = mkIf cfg.enable {
    services.tailscale.enable = true;

    environment.systemPackages = with pkgs; [ tailscale ];
  };
}
