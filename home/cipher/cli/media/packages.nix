{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  inherit (config) modules;

  env = modules.usrEnv;
  prg = env.programs;
  cfg = prg.media;
in {
  config.hm = mkIf cfg.addDefaultPackages {
    home.packages = with pkgs;
      [
        # tools that help with media operations/management
        ffmpeg-full # Complete, cross-platform solution to record, convert and stream audio and video
        yt-dlp # Command-line tool to download videos from YouTube.com and other sites (youtube-dl fork)
        mpc
        playerctl # Command-line utility and library for controlling media players that implement MPRIS
        pulsemixer # Cli and curses mixer for pulseaudio
        musikcube # Terminal-based music player, library, and streaming audio server
      ]
      ++ cfg.extraPackages;
  };
}
