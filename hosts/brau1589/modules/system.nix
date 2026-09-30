{ lib
, pkgs
, ...
}: {
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


      boot = {
        # Newer amdgpu/NVIDIA-open fixes and NTSYNC for Proton; this host has
        # no ZFS, so it is not held back by out-of-tree ZFS support.
        kernel = pkgs.linuxPackages_latest;
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

    # Power profiles (performance / balanced / power-saver) via
    # power-profiles-daemon, mapped onto the ROG platform profiles
    # (quiet / balanced / performance). Replaces auto-cpufreq's governor
    # handling on this host.
    services.power-profiles-daemon.enable = true;
    services.auto-cpufreq.enable = false;

    # PRIME offload stays (HDMI-A-1 is wired to the Renoir iGPU, so the
    # dGPU can sleep while docked). Games opt into the RTX 3050 Ti with
    # `nvidia-offload %command%` in their launch options. Dynamic Boost
    # lets nvidia-powerd shift power from the CPU to the dGPU under load.
    hardware.nvidia.dynamicBoost.enable = true;

    security.pki.certificates = [
      (builtins.readFile ../certs/ca.pem)
    ];

    sops.secrets.vaultwarden_server_key = { };

    networking = {
      networkmanager.dns = "none";
      nameservers = [ "127.0.0.1" ];
    };

    systemd.timers."snapshot-home".enable = lib.mkForce false;
    systemd.services."snapshot-home".enable = lib.mkForce false;
  };
}
