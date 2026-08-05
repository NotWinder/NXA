{ lib, ... }:
let
  inherit (lib) mkEnableOption mkOption types;
in
{
  options.custom.system.services = {
    # database backends
    database = {
      mysql = {
        enable = mkEnableOption "MySQL database service";

        settings = {
          host = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = "The host MySQL will listen on";
          };
          port = mkOption {
            type = types.int;
            default = 3306;
            description = "The port MySQL will listen on";
          };
        };
      };

      mongodb = {
        enable = mkEnableOption "MongoDB database service";

        settings = {
          host = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = "The host MongoDB will listen on";
          };
          port = mkOption {
            type = types.int;
            default = 27017;
            description = "The port MongoDB will listen on";
          };
        };
      };

      redis = {
        enable = mkEnableOption "Redis database service";

        settings = {
          host = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = "The host Redis will listen on";
          };
          port = mkOption {
            type = types.int;
            default = 6379;
            description = "The port Redis will listen on";
          };
        };
      };

      postgresql = {
        enable = mkEnableOption "PostgreSQL database service";

        settings = {
          host = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = "The host PostgreSQL will listen on";
          };
          port = mkOption {
            type = types.int;
            default = 5432;
            description = "The port PostgreSQL will listen on";
          };
        };
      };

      garage = {
        enable = mkEnableOption "Garage S3 storage service";

        settings = {
          host = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = "The host Garage will listen on";
          };
          port = mkOption {
            type = types.int;
            default = 5432;
            description = "The port Garage will listen on";
          };
        };
      };
    };
  };
}
