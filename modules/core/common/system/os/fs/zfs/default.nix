{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.modules.system;
in {
  config = mkIf (cfg.fs.zfs.enable) {
    boot = {
      supportedFilesystems = ["zfs"];
      zfs = {
        extraPools = ["wpool"];
        forceImportRoot = false;
      };
    };
  };
}
