{
  imports = [
    ./systemd
    ./databases # mysql, postgreqsl, redis and more
    ./nginx # base nginx webserver configuration
    ./networking # wireguard and headscale

    ./tor.nix # tor relay
    ./searxng.nix # searx search engine

    ./fwupd.nix
    ./getty.nix
    ./jellyfin.nix
    ./ntpd.nix
    ./prowlarr.nix
    ./radarr.nix
    ./sonarr.nix
    ./thermald.nix
    ./xray.nix
    ./zram.nix
  ];
}
