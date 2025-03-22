{
  osConfig,
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules;

  env = modules.usrEnv;
  prg = env.programs;
in {
  programs.beets = mkIf prg.media.beets.enable {
    enable = true;

    settings = {
      ui.color = true;
      directory = "${config.services.mpd.musicDirectory}/library";
      library = "${config.services.mpd.musicDirectory}/musiclibrary.db";

      clutter = [
        "Thumbs.DB"
        ".DS_Store"
        ".directory"
      ];

      plugins = [
        "duplicates"
        "edit"
        "fromfilename"
        "fuzzy"
        "info"
        "inline"
        "lyrics"
        "mbcollection"
        "mbsync"
        "mpdupdate"
        "replaygain"
        "unimported"
      ];

      import = {
        autotag = false;
        bell = true;
        copy = false;
        detail = true;
        log = "/home/winder/Media/Music/beets/importer.log";
        move = false;
        timid = true;
        write = false;
      };

      replace = {
        "\\ " = "-";
      };

      mpd = {
        host = "127.0.0.1";
        port = 6600;
      };

      lyrics = {
        auto = true;
      };

      replaygain.backend = "gstreamer";
      musicbrainz = {
        user = "notwinder";
        pass = "zzfyWvjiaNUMBYhu#t2se4";
      };
    };
  };
}
