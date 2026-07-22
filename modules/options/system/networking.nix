{ lib, ... }:
let
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) bool;
in
{
  options.custom.system.networking = {
    optimizeTcp = mkEnableOption "TCP optimization parameters for better network performance";

    nftables = {
      enable = mkEnableOption "the nftables firewall";
    };

    tailscale = {
      enable = mkEnableOption "Tailscale zero-config VPN";

      isClient = mkOption {
        type = bool;
        default = false;
        description = "Whether the host should act as a Tailscale client";
      };

      isServer = mkOption {
        type = bool;
        default = false;
        description = "Whether the host should act as a Tailscale server (subnet router/exit node)";
      };
    };
  };
}
