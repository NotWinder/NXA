{
  inputs',
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  inherit (osConfig) modules;

  env = modules.usrEnv;
  prg = env.programs;
  cfg = prg.media;
in {
  config = mkIf cfg.addDefaultPackages {
    home.packages = with pkgs;
      [
        # tools that help with media operations/management
        ffmpeg-full # Complete, cross-platform solution to record, convert and stream audio and video
        yt-dlp # Command-line tool to download videos from YouTube.com and other sites (youtube-dl fork)
        #mpc-cli
        playerctl # Command-line utility and library for controlling media players that implement MPRIS
        pavucontrol # PulseAudio Volume Control
        pulsemixer # Cli and curses mixer for pulseaudio
        imv # Command line image viewer for tiling window managers
        cantata # Graphical client for MPD
        easytag # View and edit tags for various audio files
        kid3 # Simple and powerful audio tag editor
        musikcube # Terminal-based music player, library, and streaming audio server

        # get ani-cli  from my own package collection
        # I usually don't want to wait for nixpkgs
        inputs'.nyxexprs.packages.ani-cli
      ]
      ++ cfg.extraPackages;
  };
}
