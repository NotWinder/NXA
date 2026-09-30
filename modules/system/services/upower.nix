{ lib, ... }: {
  services.upower.enable = true;
  # Off unless a host opts in (brau1589). Priority 900 sits just above the
  # mkDefault true set by DankMaterialShell's NixOS module, so enabling dms
  # does not start power-profiles-daemon alongside auto-cpufreq.
  services.power-profiles-daemon.enable = lib.mkOverride 900 false;
}
