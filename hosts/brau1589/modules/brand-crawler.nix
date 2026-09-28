{
  systemd.services.brand-crawler = {
    description = "Brand crawler (scrape + download trademark PDFs)";
    wants = [ "network-online.target" ];
    after = [ "network-online.target" "docker.service" ];
    serviceConfig = {
      Type = "oneshot";
      WorkingDirectory = "/opt/brand-crawler";
      # Only the crawler service is brought up here; the always-on api/bot
      # containers are managed by brand-crawler-stack.
      ExecStart = "/opt/brand-crawler/deploy/run-crawler.sh up --abort-on-container-exit crawler";
      # Remove only this run's container; never tear down the api/bot stack.
      ExecStopPost = "/opt/brand-crawler/deploy/run-crawler.sh rm -f crawler";
      TimeoutStartSec = 0;
      TimeoutStopSec = 120;
      StandardOutput = "journal";
      StandardError = "journal";
    };
  };

  systemd.services.brand-crawler-stack = {
    # Disabled: production operator moved to comp-jarvis; brau1589 is dev/verification only.
    enable = false;
    description = "Brand crawler always-on services (operator API + bot)";
    wants = [ "network-online.target" ];
    after = [ "network-online.target" "docker.service" ];
    serviceConfig = {
      Type = "oneshot";
      WorkingDirectory = "/opt/brand-crawler";
      ExecStart = "/opt/brand-crawler/deploy/run-crawler.sh up -d api bot";
      TimeoutStartSec = 120;
      TimeoutStopSec = 60;
      StandardOutput = "journal";
      StandardError = "journal";
    };
    wantedBy = [ ];
  };

  systemd.paths.brand-crawler-manual = {
    description = "Trigger the brand crawler when a manual run is requested";
    pathConfig = {
      # The operator bot (/run) and the API (POST /crawler/run) write this
      # file to request a one-off crawl; the path unit starts
      # brand-crawler.service.
      Unit = "brand-crawler.service";
      PathChanged = "/opt/brand-crawler/data/run.request.json";
    };
    wantedBy = [ "multi-user.target" ];
  };
  # Daily timer removed: comp-jarvis (Ubuntu) is the production operator
  # host since 2026-08-17; brau1589 stays as dev/verification box only.
}
