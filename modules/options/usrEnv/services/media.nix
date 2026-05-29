{ config
, lib
, ...
}:
let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) str;
  inherit (config) custom;

  sys = custom.system;
in
{
  options.custom.usrEnv.services.media = {
    mpd = {
      enable = mkEnableOption "mpd service";
      musicDirectory = mkOption {
        type = str;
        default = "${sys.homePath}";
      };
    };
  };
}
