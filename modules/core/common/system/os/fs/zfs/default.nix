{
  boot.supportedFilesystems = ["zfs"];
  boot.zfs.extraPools = ["wpool"];
  boot.zfs.forceImportRoot = false;
}
