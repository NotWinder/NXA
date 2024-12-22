{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf (lib.isx86Linux pkgs) {
    services.dbus.apparmor = "enabled";

    environment.systemPackages = with pkgs; [
      apparmor-pam
      apparmor-utils
      apparmor-parser
      apparmor-profiles
      apparmor-bin-utils
      apparmor-kernel-patches
      libapparmor
    ];

    # apparmor configuration
    security.apparmor = {
      enable = true;

      # whether to enable the AppArmor cache
      # in /var/cache/apparmore
      enableCache = true;

      # whether to kill processes which have an AppArmor profile enabled
      # but are not confined (AppArmor can only confine new processes)
      killUnconfinedConfinables = true;

      # packages to be added to AppArmor’s include path
      packages = [pkgs.apparmor-profiles];

      # TODO: includes
    };
  };
}
