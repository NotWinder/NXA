{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  sys = config.modules.system;
  cfg = sys.services.sing-box;
in {
  config = mkIf cfg.enable {
    sops.secrets = {
      "sing-box-url" = {
        owner = cfg.user;
        group = cfg.group;
      };
    };
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
    };
    users.groups.${cfg.group} = {};

    # Define the systemd service unit from scratch
    systemd.services.sing-box = {
      description = "Custom sing-box proxy service";
      wantedBy = ["default.target"];

      # This script runs before the main command
      preStart = ''
        # Make curl available in the script's PATH
        PATH=${makeBinPath [pkgs.curl]}:$PATH

        echo "Fetching sing-box configuration for custom service..."

        # Read the URL from the sops secret file
        # IMPORTANT: This assumes you have the sops secret defined elsewhere
        # in your configuration.
        URL=$(cat ${config.sops.secrets."sing-box-url".path})

        if [ -z "$URL" ]; then
          echo "Error: The sing-box-url secret is empty!" >&2
          exit 1
        fi

        # Download the config to the service's runtime directory
        curl --fail --silent --show-error --location "$URL" \
             --output /run/sing-box/config.json

        echo "Successfully fetched custom sing-box configuration."
      '';

      # Main service configuration
      serviceConfig = {
        # Run as the user and group we created
        User = cfg.user;
        Group = cfg.group;

        # Grant the capability to manage network interfaces.
        AmbientCapabilities = ["CAP_NET_ADMIN"];
        CapabilityBoundingSet = ["CAP_NET_ADMIN"];

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
