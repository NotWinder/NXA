{ config
, lib
, pkgs
, ...
}:
let
  inherit (lib) mkIf;

  sys = config.custom.system;
  cfg = sys.services;
in
{
  config = mkIf cfg.database.mysql.enable {
    services.mysql = {
      enable = true;
      package = pkgs.mariadb;

      # databases and users
      ensureDatabases = [ "mkm" ];
      ensureUsers = [
        {
          name = "mkm";
          ensurePermissions = {
            "mkm.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };
  };
}
