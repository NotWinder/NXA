{ config
, lib
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

      # Newer amdgpu/NVIDIA-open fixes and NTSYNC for Proton; this host has
      # no ZFS, so it is not held back by out-of-tree ZFS support.
      boot.kernel = pkgs.linuxPackages_latest;
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
    # Run as a unit ordered after the daemon (at boot the udev event fires
    # before it is up, so a direct powerprofilesctl call fails) and match only
    # Mains: the USB-C UCSI supply reports online=0 whenever no PD charger is
    # attached, which used to force power-saver while on the barrel adapter.
    systemd.services.ppd-ac-sync = {
      description = "Match power profile to AC state";
      wants = [ "power-profiles-daemon.service" ];
      after = [ "power-profiles-daemon.service" ];
      # graphical.target, not multi-user.target: ppd is ordered after
      # multi-user.target, so that would be an ordering cycle.
      wantedBy = [ "graphical.target" ];
      serviceConfig.Type = "oneshot";
      script = ''
        if grep -qx 1 /sys/class/power_supply/ADP0/online; then
          ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced
        else
          ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver
        fi
      '';
    };
    services.udev.extraRules = ''
      SUBSYSTEM=="power_supply", ATTR{type}=="Mains", RUN+="${config.systemd.package}/bin/systemctl start --no-block ppd-ac-sync.service"
    '';

    # PRIME offload stays (HDMI-A-1 is wired to the Renoir iGPU, so the
    # dGPU can sleep while docked). Games opt into the RTX 3050 Ti with
    # `nvidia-offload %command%` in their launch options. Dynamic Boost lifts
    # the dGPU from 60W to 75W under load (measured ~1720 -> ~1890 MHz).
    # nvidia-powerd works once the driver is up but can fail at boot ("Allocate
    # Root client failed 0x6a"), and the nixpkgs unit has no ordering, so retry.
    # The "DC power limits table is not supported" errors are the SBIOS
    # disabling Dynamic Boost on battery, which is expected.
    hardware.nvidia.dynamicBoost.enable = true;
    systemd.services.nvidia-powerd.serviceConfig = {
      Restart = "on-failure";
      RestartSec = 5;
    };

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
