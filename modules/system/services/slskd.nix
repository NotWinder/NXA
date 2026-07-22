{ config
, lib
, ...
}:
let
  inherit (lib) mkIf;

  sys = config.custom.system;
  cfg = sys.services;
in
{
  config = mkIf cfg.slskd.enable {
    services.slskd = {
      enable = true;
      openFirewall = true;
      domain = "127.0.0.1";
      environmentFile = "${sys.homePath}/env";
      settings = {
        shares.directories = [ "${sys.homePath}/Media/Music/primary/Music/library" ];
        directories = {
          downloads = "${sys.homePath}/Media/Music/primary/Music/not-picarded";
          incomplete = "/var/lib/slskd/incomplete";
        };
      };
    };
  };
}
