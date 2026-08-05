{ lib, ... }:
let
  inherit (lib) mkEnableOption mkOption types;
in
{
  options.custom.system.services = {
    # networking
    networking = {
      wireguard.enable = mkEnableOption "Wireguard service";

      headscale = {
        enable = mkEnableOption "Headscale networking service";

        settings = {
          host = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = "The host Headscale will listen on";
          };
          port = mkOption {
            type = types.int;
            default = 8085;
            description = "The port Headscale will listen on";
          };
        };
      };
    };
  };
}
