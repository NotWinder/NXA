{ config, lib, ... }:
with lib; let
  sys = config.custom.system;
  cfg = sys.services.networking.wireguard;
in
{
  config = mkIf cfg.enable {
    sops.secrets.wireguard_private_key = {
      mode = "0600";
      owner = "root";
    };

    networking.wireguard.interfaces.wg0 = {
      ips = [ "10.10.0.3/24" ];
      privateKeyFile = config.sops.secrets.wireguard_private_key.path;
      peers = [
        {
          publicKey = "f9LTz7d+DNijFKU8SMCGUWXiGnQ2T/GsSNTi8SRfXSE=";
          endpoint = "85.133.224.202:51820";
          allowedIPs = [ "10.10.0.0/24" "10.10.1.0/24" ];
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
