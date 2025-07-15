{
  inputs',
  config,
  lib,
  ...
}: {
  # Configuration files
  # Data files
  xdg.configFile = let
    winpaper = inputs'.winpaper.packages;
  in {
    # Scripts directory (from the packaged scripts)
    "caelestia/shell.json" = {
      text = ''
        {
            "paths": {
                "wallpaperDir": "${winpaper.wallpkgs}/share/wallpapers/"
            }
        }
      '';
    };
  };

  # Environment variables
  home.sessionVariables = {
    C_DATA = "${config.xdg.dataHome}/caelestia";
    C_STATE = "${config.xdg.stateHome}/caelestia";
    C_CACHE = "${config.xdg.cacheHome}/caelestia";
    C_CONFIG = "${config.xdg.configHome}/caelestia";
  };

  # Directory setup and permissions
  home.activation.caelestiaSetup = lib.hm.dag.entryAfter ["writeBoundary"] ''
     # Create required directories
     mkdir -p ${config.xdg.dataHome}/caelestia
     mkdir -p ${config.xdg.stateHome}/caelestia/scheme
     mkdir -p ${config.xdg.cacheHome}/caelestia/thumbnails
     mkdir -p ${config.xdg.configHome}/caelestia

     # Ensure state files are writable (fix permission issues)
    #if [ -d ${config.xdg.stateHome}/caelestia/scheme ]; then
    #  find ${config.xdg.stateHome}/caelestia/scheme -name "*.txt" -exec chmod u+w {} \; 2>/dev/null || true
    #fi
  '';
}
