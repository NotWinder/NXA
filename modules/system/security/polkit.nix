{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
in {
  # start the Pantheon policykit agent
  # this is based on the GNOME policykit agent
  # but uses a newer GTK version
  systemd = mkIf sys.video.enable {
    user.services.pantheon-agent-polkit-1 = {
      description = "kde PolicyKit agent";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.pantheon.pantheon-agent-polkit}/result/libexec/polkit-kde-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };

      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
    };
  };
}
