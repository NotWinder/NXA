{
  imports = [
    ./systemd
    ./databases # mysql, postgreqsl, redis and more
    ./nginx # base nginx webserver configuration
    ./networking # wireguard and headscale
    ./login

    ./dbus.nix
    ./earlyoom.nix
    ./fwupd.nix
    ./getty.nix
    ./gnome.nix
    ./jellyfin.nix
    ./location.nix
    ./misc.nix
    ./ntpd.nix
    ./printing.nix
    ./prowlarr.nix
    ./radarr.nix
    ./runners.nix
    ./searxng.nix
    ./sonarr.nix
    ./systemd.nix
    ./thermald.nix
    ./upower.nix
    ./xray.nix
    ./xserver.nix
    ./zram.nix
    ./zswap.nix
  ];
}
