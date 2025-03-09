## Jellyfin
{
  systemd.services.jellyfin.environment = {
    http_proxy = "http://127.0.0.1:10809";
  };
  services.jellyfin = {
    enable = true;
  };
}
