{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
in {
  config = mkIf sys.security.tor.enable {
    services = {
      tor = {
        enable = true;
        torsocks.enable = true;
        client = {
          enable = true;
          dns.enable = true;
        };
      };

      networkd-dispatcher = {
        enable = true;
      };
    };

    programs.proxychains = {
      enable = true;
      quietMode = false;
      proxyDNS = true;
      package = pkgs.proxychains-ng;
      proxies = {
        tor = {
          type = "socks5";
          host = "127.0.0.1";
          port = 9050;
        };
      };
    };
  };
}
