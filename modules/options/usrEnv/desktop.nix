{ config
, lib
, ...
}:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) bool enum;

  cfg = config.custom.usrEnv;
  sys = config.custom.system;
in
{
  options.custom.usrEnv = {
    desktop = mkOption {
      type = enum [ "none" "Hyprland" "sway" "niri" "plasma" ];
      default = "none";
      description = ''
        The desktop environment to be used.
      '';
    };

    useHomeManager = mkOption {
      type = bool;
      default = true;
      description = ''
        Whether to enable the usage of home-manager for user home
        management. My home-manager module will map the list of users to
        their home directories inside the `homes/` directory in the
        repository root.

        ::: {.warning}
        Username via `custom.system.mainUser` must be set if
        this option is enabled.
        :::
      '';
    };
  };

  config = {
    assertions = [
      {
        assertion = cfg.useHomeManager -> sys.mainUser != null;
        message = "custom.system.mainUser must be set while custom.usrEnv.useHomeManager is enabled";
      }
    ];
  };
}
