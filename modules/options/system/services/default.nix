{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkService mkEnableOption mkPackageOption mkOption types;
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

      sing-box = {
        enable = mkEnableOption "sing-box service";
        package = mkPackageOption pkgs "sing-box" {};

        user = mkOption {
          type = types.str;
          default = "sing-box";
          description = "User to run the sing-box service as.";
        };

        group = mkOption {
          type = types.str;
          default = "sing-box";
          description = "Group to run the sing-box service as.";
        };
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

      lidarr = mkService {
        name = "Lidarr";
        type = "media";
        port = 8686;
      };

      slskd = mkService {
        name = "Slskd";
        type = "media";
        port = 5030;
      };
    };
  };
}
