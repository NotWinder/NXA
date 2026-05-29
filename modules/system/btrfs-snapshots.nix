{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) length attrNames;
  inherit (lib.modules) mkIf;
  inherit (lib.attrsets) filterAttrs;

  btrfsMounts = filterAttrs (_: mount: mount.fsType == "btrfs") config.fileSystems;
  hasHomeSubvolume = length (attrNames (filterAttrs (_: mount: mount.mountPoint == "/home") btrfsMounts)) > 0;
in {
  config = mkIf (length (attrNames btrfsMounts) > 0) {
    systemd = {
      tmpfiles.settings."10-snapshots"."/var/lib/snapshots".d = {
        user = "root";
        group = "root";
        age = "30d";
      };

      timers."snapshot-home" = {
        enable = hasHomeSubvolume;
        description = "snapshot home subvolume";
        wantedBy = ["multi-user.target"];
        timerConfig = {
          OnCalendar = "weekly";
          Persistent = true;
        };
      };

      services."snapshot-home" = {
        enable = hasHomeSubvolume;
        path = [pkgs.btrfs-progs];
        script = "btrfs subvolume snapshot /home /var/lib/snapshots/$(date +%s)";
      };
    };
  };
}
