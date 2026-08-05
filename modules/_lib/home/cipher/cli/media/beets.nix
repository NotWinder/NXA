{config, lib, osConfig, ...}:
let
  inherit (lib.modules) mkIf;
  inherit (osConfig) custom;

  env = custom.usrEnv;
  prg = env.programs;
in
{
  config = {
    programs.beets = mkIf prg.media.beets.enable {
      enable = true;

      settings = {
        ui.color = true;
        directory = "${osConfig.services.mpd.settings.music_directory}/library";
        library = "${osConfig.services.mpd.settings.music_directory}/musiclibrary.db";

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
          log = "${osConfig.custom.system.homePath}/Media/Music/beets/importer.log";
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
  };
}
