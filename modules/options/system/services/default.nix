{lib, ...}: let
  inherit (lib) mkService;
  inherit (lib.options) mkEnableOption;
in {
  imports = [
    ./bincache.nix # TODO: check if it would be used (server config)
    ./databases.nix # TODO: server related i'll check after desktop is done
    ./monitoring.nix # TODO: check i'll be able to use it if not delete it (after desktop is done)
    ./networking.nix # TODO: see above
    ./social.nix # TODO: see above
  ];

  options.modules.system = {
    services = {
      mailserver.enable = mkEnableOption "nixos-mailserver service"; # TODO: server related
      mkm.enable = mkEnableOption "mkm-ticketing service"; # TODO: server related

      nginx = mkService {
        # TODO: server related
        name = "Nginx";
        type = "webserver";
      };

      vaultwarden = mkService {
        # TODO: server related
        name = "Vaultwarden";
        type = "password manager";
        port = 8222;
        host = "127.0.0.1";
      };

      forgejo = mkService {
        # TODO: server related
        name = "Forgejo";
        type = "forge";
        port = 7000;
      };

      quassel = mkService {
        # TODO: server related
        name = "Quassel";
        type = "IRC";
        port = 4242;
      };

      jellyfin = mkService {
        # TODO: server related
        name = "Jellyfin";
        type = "media";
        port = 8096;
      };

      searxng = mkService {
        # TODO: server related
        name = "Searxng";
        type = "meta search engine";
        port = 8888;
      };

      miniflux = mkService {
        # TODO: server related
        name = "Miniflux";
        type = "RSS reader";
      };

      reposilite = mkService {
        # TODO: server related
        name = "Reposilite";
        port = 8084;
      };

      elasticsearch = mkService {
        # TODO: server related
        name = "Elasticsearch";
        port = 9200;
      };

      kanidm = mkService {
        # TODO: server related
        name = "Kanidm";
        port = 8443;
      };
    };
  };
}
