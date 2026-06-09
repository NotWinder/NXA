{config, ...}: {
  services = {
    # Replace chrony with systemd-timesyncd
    # I am yet to confirm the difference in accuracy
    # but systemd-timesyncd is a part of the systemd
    # ecosystem, which we are already a part of by
    # the virtue of using NixOS.
    chrony.enable = false;
    timesyncd = {
      enable = true;
      servers = config.networking.timeServers; # default value
      settings.PollIntervalMinSec = 128;
    };
  };
}
