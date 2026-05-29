{
  imports = [
    ./systemd
    ./databases # mysql, postgreqsl, redis and more
    ./networking # wireguard and headscale
    ./login

    ./cron.nix
    ./dbus.nix
    ./earlyoom.nix
    #./fwupd.nix
    ./getty.nix
    ./gnome.nix
    ./jellyfin.nix
    ./lidarr.nix
    ./location.nix
    ./misc.nix
    #./navidrome.nix
    ./ntpd.nix
    ./printing.nix
    ./prowlarr.nix
    ./radarr.nix
    ./runners.nix
    ./searxng.nix
    ./sing-box.nix
    ./slskd.nix
    ./sonarr.nix
    ./syncthing.nix
    ./systemd.nix
    ./thermald.nix
    ./upower.nix
    ./xserver.nix
    ./zram.nix
   #./zswap.nix
  ];
  systemd.network.wait-online.enable = false;
  systemd.services."systemd-tmpfiles-clean".serviceConfig.ExecStart = [""];
  systemd.timers."systemd-tmpfiles-clean".enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;
  boot.blacklistedKernelModules = ["serial8250" "tpm" "tpm_tis" "tpm_crb"];
}
