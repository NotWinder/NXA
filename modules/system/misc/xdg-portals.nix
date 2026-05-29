{ config
, lib
, ...
}:
let
  sys = config.custom.system;
  inherit (lib) mkIf;
in
{
  config = mkIf sys.video.enable {
    xdg.portal.config = {
      common = {
        "org.freedesktop.impl.portal.Secret" = [
          "gnome-keyring"
        ];
      };
    };
  };
}
