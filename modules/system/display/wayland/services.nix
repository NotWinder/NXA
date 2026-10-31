{ config
, lib
, pkgs
, ...
}:
let
  inherit (lib) mkIf getExe;

  cfg = config.custom.system.video;
in
{
  config = mkIf cfg.enable {
    systemd.services = {
      seatd = {
        enable = true;
        description = "Seat management daemon";
        script = "${getExe pkgs.seatd} -g wheel";
        serviceConfig = {
          Type = "simple";
          Restart = "always";
          RestartSec = "1";
        };
        wantedBy = [ "multi-user.target" ];
        # Restarting seatd drops the compositor's libseat connection and niri
        # panics, sending you back to greetd. Apply the new seatd on reboot.
        restartIfChanged = false;
        stopIfChanged = false;
      };
    };
  };
}
