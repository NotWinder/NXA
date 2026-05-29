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
  config = mkIf cfg.database.mongodb.enable {
    services.mongodb = {
      enable = true;
      package = pkgs.mongodb;
      enableAuth = true;
      initialRootPassword = config.age.secrets.mongodb-secret.path;
      #bind_ip = "0.0.0.0";
      extraConfig = ''
        operationProfiling.mode: all
      '';
    };
  };
}
