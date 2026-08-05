{ lib
, pkgs
, ...
}:
let
  inherit (lib) mkEnableOption mkOption mkPackageOption types;
in
{
  imports = [
    ./databases.nix
    ./networking.nix
  ];

  options.custom.system = {
    services = {
      nginx = {
        enable = mkEnableOption "Nginx webserver service";

        settings = {
          host = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = "The host Nginx will listen on";
          };
          port = mkOption {
            type = types.int;
            default = 0;
            description = "The port Nginx will listen on";
          };
        };
      };

      sing-box = {
        enable = mkEnableOption "sing-box service";
        package = mkPackageOption pkgs "sing-box" { };

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

      vaultwarden = {
        enable = mkEnableOption "Vaultwarden password manager service";

        settings = {
          host = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = "The host Vaultwarden will listen on";
          };
          port = mkOption {
            type = types.int;
            default = 8222;
            description = "The port Vaultwarden will listen on";
          };
        };
      };

      jellyfin = {
        enable = mkEnableOption "Jellyfin media service";

        settings = {
          host = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = "The host Jellyfin will listen on";
          };
          port = mkOption {
            type = types.int;
            default = 8096;
            description = "The port Jellyfin will listen on";
          };
        };
      };

      searxng = {
        enable = mkEnableOption "Searxng meta search engine service";

        settings = {
          host = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = "The host Searxng will listen on";
          };
          port = mkOption {
            type = types.int;
            default = 8888;
            description = "The port Searxng will listen on";
          };
        };
      };

      sonarr = {
        enable = mkEnableOption "Sonarr media service";

        settings = {
          host = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = "The host Sonarr will listen on";
          };
          port = mkOption {
            type = types.int;
            default = 8989;
            description = "The port Sonarr will listen on";
          };
        };
      };

      radarr = {
        enable = mkEnableOption "Radarr media service";

        settings = {
          host = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = "The host Radarr will listen on";
          };
          port = mkOption {
            type = types.int;
            default = 7878;
            description = "The port Radarr will listen on";
          };
        };
      };

      prowlarr = {
        enable = mkEnableOption "Prowlarr media service";

        settings = {
          host = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = "The host Prowlarr will listen on";
          };
          port = mkOption {
            type = types.int;
            default = 9696;
            description = "The port Prowlarr will listen on";
          };
        };
      };

      lidarr = {
        enable = mkEnableOption "Lidarr media service";

        settings = {
          host = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = "The host Lidarr will listen on";
          };
          port = mkOption {
            type = types.int;
            default = 8686;
            description = "The port Lidarr will listen on";
          };
        };
      };

      slskd = {
        enable = mkEnableOption "Slskd media service";

        settings = {
          host = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = "The host Slskd will listen on";
          };
          port = mkOption {
            type = types.int;
            default = 5030;
            description = "The port Slskd will listen on";
          };
        };
      };
    };
  };
}
