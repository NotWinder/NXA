{
  config.custom.system = {
    services = {
      jellyfin.enable = true;
      lidarr.enable = true;
      prowlarr.enable = true;
      radarr.enable = true;
      sing-box.enable = true;
      sonarr.enable = true;
    };

    fs.zfs.enable = true;

    virtualisation.docker.enable = false;
  };
}
