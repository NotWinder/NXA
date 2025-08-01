{lib, ...}: let
  inherit (lib) mkService;
in {
  imports = [
    ./databases.nix
    ./networking.nix
  ];

  options.modules.system = {
    services = {
      nginx = mkService {
        name = "Nginx";
        type = "webserver";
      };

      xray = mkService {
        name = "Xray";
        type = "proxy";
      };

      sing-box = mkService {
        name = "sing-box";
        type = "proxy";
      };

      vaultwarden = mkService {
        name = "Vaultwarden";
        type = "password manager";
        port = 8222;
        host = "127.0.0.1";
      };

      jellyfin = mkService {
        name = "Jellyfin";
        type = "media";
        port = 8096;
      };

      searxng = mkService {
        name = "Searxng";
        type = "meta search engine";
        port = 8888;
      };

      sonarr = mkService {
        name = "Sonarr";
        type = "media";
        port = 8989;
      };

      radarr = mkService {
        name = "Radarr";
        type = "media";
        port = 7878;
      };

      prowlarr = mkService {
        name = "Prowlarr";
        type = "media";
        port = 9696;
      };
    };
  };
}
