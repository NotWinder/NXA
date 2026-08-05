{ config
, pkgs
, lib
, osConfig
, ...
}:
let
  inherit (lib.modules) mkIf;

  env = osConfig.custom.usrEnv;
  srv = env.services;
in
{
  config = mkIf srv.media.mpd.enable {
    home.packages = with pkgs; [
      playerctl # CLI interface for playerctld
    ];
    services = {
      playerctld.enable = true;
      mpris-proxy.enable = true;
      mpd-mpris.enable = true;

      # MPRIS 2 support to mpd
      mpdris2 = {
        enable = true;
        notifications = true;
        multimediaKeys = true;
        mpd = {
          musicDirectory = "/mnt/media/music";
        };
      };

      # discord rich presence for mpd
      mpd-discord-rpc = {
        enable = true;
        settings = {
          format = {
            details = "$title";
            state = "On $album by $artist";
            large_text = "$album";
            small_image = "";
          };
        };
      };
    };
  };
}