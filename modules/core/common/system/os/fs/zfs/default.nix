{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.modules.system;
in {
  config = mkIf (cfg.fs.zfs.enable) {
    boot.supportedFilesystems = ["zfs"];
    boot.zfs.extraPools = ["wpool"];
    boot.zfs.forceImportRoot = false;
  };
}
