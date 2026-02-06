{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (config) modules;

  env = modules.usrEnv;
  srv = env.services;
in {
  config = mkIf srv.media.mpd.enable {
    #hm = {
    #  home.packages = with pkgs; [
    #    playerctl # CLI interface for playerctld
    #  ];
    #  services = {
    #    playerctld.enable = true;
    #    mpris-proxy.enable = true;
    #    mpd-mpris.enable = true;

    #    # MPRIS 2 support to mpd
    #    mpdris2 = {
    #      enable = true;
    #      notifications = true;
    #      multimediaKeys = true;
    #      mpd = {
    #        # for some reason config.xdg.userDirs.music is not a "path" - possibly because it has $HOME in its name?
    #        inherit (config.services.mpd) musicDirectory;
    #      };
    #    };

    #    # discord rich presence for mpd
    #    mpd-discord-rpc = {
    #      enable = true;
    #      settings = {
    #        format = {
    #          details = "$title";
    #          state = "On $album by $artist";
    #          large_text = "$album";
    #          small_image = "";
    #        };
    #      };
    #    };
    #  };
    #};
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
