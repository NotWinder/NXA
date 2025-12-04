{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.strings) concatStringsSep;
  inherit (lib.meta) getExe;

  sys = config.modules.system;

  # make desktop session paths available to greetd
  sessionData = config.services.displayManager.sessionData.desktops;
  sessionPaths = concatStringsSep ":" [
    "${sessionData}/share/xsessions"
    "${sessionData}/share/wayland-sessions"
  ];

  initialSession = {
    user = "${sys.mainUser}";
    command = "${config.custom.services.greetd.autoLogin.command}";
  };

  defaultSession = {
    user = "greeter";
    command = concatStringsSep " " [
      (getExe pkgs.tuigreet)
      "--time"
      "--remember"
      "--remember-user-session"
      "--asterisks"
      "--sessions '${sessionPaths}'"
    ];
  };
in {
  options.custom.services.greetd = {
    enable = lib.mkEnableOption "Greetd login manager";
    autoLogin = {
      enable = lib.mkEnableOption "Enable automatic login for the main user";
      command = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          The command to run for the automatic login session.
        '';
      };
    };
  };

  config = mkIf config.custom.services.greetd.enable {
    services.greetd = {
      enable = true;
      restart = !config.custom.services.greetd.autoLogin.enable;

      # <https://man.sr.ht/~kennylevinsen/greetd/>
      settings = {
        # default session is what will be used if no session is selected
        # in this case it'll be a TUI greeter
        default_session = defaultSession;

        # initial session
        initial_session = mkIf config.custom.services.greetd.autoLogin.enable initialSession;
      };
    };

    # Suppress error messages on tuigreet. They sometimes obscure the TUI
    # boundaries of the greeter.
    # See: https://github.com/apognu/tuigreet/issues/68#issuecomment-1586359960
    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInputs = "tty";
      StandardOutput = "tty";
      StandardError = "journal";
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
  };
}
