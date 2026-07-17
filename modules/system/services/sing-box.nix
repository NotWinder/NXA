{ config
, lib
, pkgs
, ...
}:
with lib; let
  sys = config.custom.system;
  cfg = sys.services.sing-box;
in
{
  config = mkIf cfg.enable {
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
    };
    users.groups.${cfg.group} = { };

    # Define the systemd service unit from scratch
    systemd.services.sing-box = {
      description = "Custom sing-box proxy service";
      wantedBy = [ "default.target" ];

      preStart = ''
        echo "sing-box config must be placed at /run/sing-box/config.json"
      '';

      # Main service configuration
      serviceConfig = {
        # Run as the user and group we created
        User = cfg.user;
        Group = cfg.group;

        # Grant the capability to manage network interfaces.
        AmbientCapabilities = [ "CAP_NET_ADMIN" ];
        CapabilityBoundingSet = [ "CAP_NET_ADMIN" ];

        # Systemd will create and manage these directories
        StateDirectory = "sing-box";
        RuntimeDirectory = "sing-box";

        # Set permissions for the created directories
        StateDirectoryMode = "0700";
        RuntimeDirectoryMode = "0700";

        # The main command to start sing-box
        ExecStart = "${cfg.package}/bin/sing-box run -C /run/sing-box";

        # Standard service options
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };
  };
}
