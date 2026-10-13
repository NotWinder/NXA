{ config, ... }: {
  # firmware updater for machine hardware
  services.fwupd = {
    enable = true;
    daemonSettings.EspLocation = config.boot.loader.efi.efiSysMountPoint;

    # Newer hardware may only have firmware in LVFS testing (e.g. Framework
    # devices). Such a host can opt in from its own config with
    # `services.fwupd.extraRemotes = [ "lvfs-testing" ];`.
  };
}
