{ config
, lib
, ...
}:
let
  inherit (lib.modules) mkIf;

  env = config.custom.usrEnv;
  srv = env.services;
in
{
  config = mkIf srv.media.mpd.enable {
    services = {
      # music player daemon service
      mpd = {
        enable = true;
        startWhenNeeded = true;
        openFirewall = true;
        settings = {
          music_directory = "/mnt/media/music";
          playlist_directory = "/mnt/media/music/primary/Music/library/playlists";
          bind_to_address = "0.0.0.0";
          port = 6600;
          auto_update = "yes";
          volume_normalization = "yes";
          restore_paused = "yes";
          filesystem_charset = "UTF-8";
          audio_output = [
            {
              type = "pipewire";
              name = "PipeWire";
            }

            {
              type = "fifo";
              name = "Visualiser";
              path = "/tmp/mpd.fifo";
              format = "44100:16:2";
            }

            {
              type = "httpd";
              name = "lossless";
              encoder = "flac";
              port = "8001";
              max_clients = "8";
              mixer_type = "software";
              format = "44100:16:2";
            }
          ];
        };
      };
    };
  };
}