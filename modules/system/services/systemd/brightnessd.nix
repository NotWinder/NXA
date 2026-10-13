{ config
, lib
, ...
}:
let
  inherit (lib) mkIf;
  inherit (config) custom;
  env = custom.usrEnv;

  cfg = env.brightness;
in
{
  config = mkIf cfg.enable {
    systemd.services."system-brightnessd" = {
      description = "Automatic backlight management with systemd";

      # A system service: graphical-session.target only exists in user
      # managers, so it can't be tied to the session (a `partOf` on it was a
      # no-op and has been dropped).
      wantedBy = [ "default.target" ];
      after = [ cfg.service.target ];

      # Not sandboxed: the usual hardening (ProtectKernelTunables, ...) makes
      # /sys read-only, and this service has to write the backlight there.
      serviceConfig = {
        Type = cfg.service.type;
        ExecStart = "${lib.getExe cfg.package}";
        Restart = "no";
      };
    };
  };
}
