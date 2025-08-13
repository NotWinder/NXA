{
  config,
  inputs',
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
    user.services.polkit-pantheon-authentication-agent-1 = {
      description = "Pantheon PolicyKit agent";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${inputs'.hyprpolkitagent.packages.default}/result/libexec/hyprpolkitagent";
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
