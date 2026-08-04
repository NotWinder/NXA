{ config
, lib
, ...
}:
let
  inherit (lib.modules) mkIf;

  dev = config.custom.device;
  acceptedTypes = [ "desktop" "laptop" "lite" "hybrid" ];
in
{
  config.hm = mkIf (builtins.elem dev.type acceptedTypes) {
    services.easyeffects = {
      enable = true;
      preset = "quiet";
    };

    xdg.configFile."easyeffects/output/quiet.json".source = ./quiet.json;
  };
}
