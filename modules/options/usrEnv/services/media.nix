{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) str;
  inherit (config) modules;

  sys = modules.system;
in {
  options.modules.usrEnv.services.media = {
    mpd = {
      enable = mkEnableOption "mpd service";
      musicDirectory = mkOption {
        type = str;
        default = "${sys.homePath}";
      };
    };
  };
}
