{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules;

  sys = modules.system;
  prg = sys.programs;
in {
  config = mkIf (prg.gui.enable && sys.video.enable) {
    home.packages = with pkgs; [
      anydesk # Desktop sharing application, providing remote support and online meetings
      easyeffects # Audio effects for PipeWire applications
      gparted # Graphical disk partitioning tool
      helvum # GTK patchbay for pipewire
      picard # Official MusicBrainz tagger
      qbittorrent # Featureful free software BitTorrent client
      telegram-desktop # Telegram Desktop messaging app
      uget # Download manager using GTK and libcurl
      universal-android-debloater # Tool to debloat non-rooted Android devices

      # Obsidian has a pandoc plugin that allows us to render and export
      # alternative image format, but as the name indicates the plugin
      # requires `pandoc` binary to be accessiblee. Join pandoc derivation
      # to Obsidian to make it available to satisfy the dependency.
      (symlinkJoin {
        name = "Obsidian";
        paths = with pkgs; [
          obsidian # Powerful knowledge base that works on top of a local folder of plain text Markdown files
          pandoc # Conversion between documentation formats
        ];
      })

      # plasma packages
      kdePackages.ark # File archiver by KDE
      kdePackages.dolphin # File manager by KDE
      kdePackages.dolphin-plugins # Plugins for Dolphin
      kdePackages.kdegraphics-thumbnailers # Thumbnailers for various graphics file formats
      kdePackages.kimageformats # KImageFormats
      kdePackages.kio # KIO
      kdePackages.kio-extras # Additional components to increase the functionality of KIO

      # Okular needs ghostscript to import PostScript files as PDFs
      # so we add ghostscript_headless as a dependency
      (symlinkJoin {
        name = "Okular";
        paths = with pkgs; [
          kdePackages.okular # KDE document viewer
          ghostscript_headless # PostScript interpreter (mainline version)
        ];
      })

      # gnome packages
      gnome-tweaks # Tool to customize advanced GNOME 3 options
      gnome-calendar # Simple and beautiful calendar application for GNOME
      komikku # Manga reader for GNOME
    ];
  };
}
