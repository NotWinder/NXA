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

    # amd_pstate's EPP under power-saver roughly doubles app launch time
    # (measured: Zen 5.0s -> 2.4s, Ghostty 2.0s -> 0.8s going power-saver ->
    # performance). Switch to balanced on AC so plugged-in launches are fast
    # for free, and drop back to power-saver on battery.
    services.udev.extraRules = ''
      SUBSYSTEM=="power_supply", ATTR{online}=="1", RUN+="${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced"
      SUBSYSTEM=="power_supply", ATTR{online}=="0", RUN+="${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver"
    '';

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
