{
  imports = [
    ./systemd
    ./databases # mysql, postgreqsl, redis and more
    ./networking # wireguard and headscale
    ./login

    ./cron.nix
    ./dbus.nix
    ./earlyoom.nix
    ./fwupd.nix
    ./getty.nix
    ./gnome.nix
    ./jellyfin.nix
    ./location.nix
    ./misc.nix
    ./navidrome.nix
    ./ntpd.nix
    ./printing.nix
    ./prowlarr.nix
    ./radarr.nix
    ./runners.nix
    ./searxng.nix
    ./sing-box.nix
    ./sonarr.nix
    ./syncthing.nix
    ./systemd.nix
    ./thermald.nix
    ./upower.nix
    ./xserver.nix
    ./zram.nix
    ./zswap.nix
  ];
}
