{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
  cfg = sys.services;
in {
  config = mkIf cfg.jellyfin.enable {
    # Because most of the websites that jellyfin gets its metadata from
    # e.g tvdb and tmdb are blocked or not reachable in my country i use
    # a proxy to bypass that (sing-box) so i set this to default to not using
    # the proxy unless it is set to be on in the config
    systemd.services.jellyfin.environment = mkIf cfg.sing-box.enable {
      http_proxy = "http://127.0.0.1:10808";
    };

    services = {
      jellyfin = {
        enable = true;
        group = "jellyfin";
        user = "jellyfin";
        openFirewall = true;
      };
    };
  };
}
