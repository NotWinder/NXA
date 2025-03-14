{
  time = {
    timeZone = "Asia/Tehran";
    hardwareClockInLocalTime = false; # this somehow breaks if Impermanence is enabled
  };

  networking.timeServers = [
    "0.nixos.pool.ntp.org"
    "1.nixos.pool.ntp.org"
    "2.nixos.pool.ntp.org"
    "3.nixos.pool.ntp.org"
  ];

  services.ntpd-rs.useNetworkingTimeServers = true;
}
