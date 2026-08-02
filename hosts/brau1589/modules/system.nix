{
  config = {
    custom.system = {
      services = {
        jellyfin.enable = true;
        prowlarr.enable = true;
        sonarr.enable = true;
        networking.wireguard.enable = true;
      };

      networking.tailscale = {
        enable = true;
        isClient = true;
      };

      fs = {
        enabledFilesystems = [ "btrfs" "vfat" "ntfs" "exfat" ];
      };

      enableSshSecrets = true;

      boot = {
        isUEFI = true;
        loader = "grub";
        plymouth.enable = false;
        secureBoot = false;
        tmpOnTmpfs = false;
      };

      virtualisation = {
        enable = true;
        qemu.enable = true;
        docker.enable = true;
      };

      security = {
        tor.enable = true;
      };
    };

    security.pki.certificates = [
      (builtins.readFile ../certs/ca.pem)
    ];

    sops.secrets.vaultwarden_server_key = { };

    networking = {
      networkmanager.dns = "none";
      nameservers = [ "127.0.0.1" ];
    };
  };
}
