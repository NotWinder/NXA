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
        ani-cli # Cli tool to browse and play anime
        euphonica # Graphical client for MPD
        easyeffects # Audio effects for PipeWire applications
        easytag # View and edit tags for various audio files
        imv # Command line image viewer for tiling window managers
        kid3 # Simple and powerful audio tag editor
        lxqt.pavucontrol-qt # Pulseaudio mixer in Qt (port of pavucontrol)
        pulsemixer # Cli and curses mixer for pulseaudio
      ]
      ++ cfg.extraPackages;
  };
}
