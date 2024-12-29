{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
  cfg = sys.services;
in {
  config = mkIf cfg.database.redis.enable {
    services.redis = {
      vmOverCommit = true;
    };
  };
}
