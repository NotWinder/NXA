{config, pkgs, lib, osConfig, ...}:
let
  inherit (lib.modules) mkIf;
  inherit (osConfig) custom;

  env = custom.usrEnv;
  prg = env.programs;
in
{
  imports = [ ./binds.nix ./settings.nix ];

  config.programs.ncmpcpp = mkIf prg.media.ncmpcpp.enable {
    enable = true;

    # provide visualisier support for ncmpcpp
    # it will optionally display a visualiser in the terminal
    # if the mpd server is configured to write the visualiser
    # mipe - e.g. /tmp/mpd.fifo
    package = pkgs.ncmpcpp.override { visualizerSupport = true; };

    # look for music tracks inside mpd's music directory
    mpdMusicDir = osConfig.services.mpd.settings.music_directory;
  };
}
