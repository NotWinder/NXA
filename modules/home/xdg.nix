# Closure-captured home-manager aspect for xdg config/mime/user-dirs
# (Phase 3c step 4).
#
# Loaded into the flake-parts module space; closes over `self` so the
# `xdgTemplate` lib function remains available without `extraSpecialArgs`.
{ self, ... }: {
  flake.modules.homeManager.xdg = { config, pkgs, lib, osConfig, ... }:
    let
      inherit (osConfig) custom;

      def = custom.usrEnv.programs.default;

      browser = [ "${def.browser}.desktop" ];
      zathura = [ "zathura.desktop" ];
      fileManager = [ "org.kde.dolphin.desktop" ];

      associations = {
        "text/html" = browser;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
        "x-scheme-handler/ftp" = browser;
        "x-scheme-handler/about" = browser;
        "x-scheme-handler/unknown" = browser;
        "application/xhtml+xml" = browser;
        "application/x-extension-htm" = browser;
        "application/x-extension-html" = browser;
        "application/x-extension-shtml" = browser;
        "application/x-extension-xhtml" = browser;
        "application/x-extension-xht" = browser;

        "inode/directory" = fileManager;
        "application/x-xz-compressed-tar" = [ "org.kde.ark.desktop" ];

        "audio/*" = [ "mpv.desktop" ];
        "video/*" = [ "mpv.desktop" ];
        "image/*" = [ "imv.desktop" ];
        "application/json" = browser;
        "application/pdf" = zathura;

        "x-scheme-handler/tg" = [ "telegramdesktop.desktop" ];
      };

      template = import self.lib.xdgTemplate "home-manager";
    in
    {
      config = {
        xdg = {
          enable = true;
          cacheHome = "${config.home.homeDirectory}/.cache";
          configHome = "${config.home.homeDirectory}/.config";
          dataHome = "${config.home.homeDirectory}/.local/share";
          stateHome = "${config.home.homeDirectory}/.local/state";

          configFile = {
            "npm/npmrc" = template.npmrc;
            "python/pythonrc" = template.pythonrc;
          };

          userDirs = {
            enable = pkgs.stdenv.isLinux;
            createDirectories = true;
            setSessionVariables = true;

            download = "${config.home.homeDirectory}/Downloads";
            desktop = "${config.home.homeDirectory}/Desktop";
            documents = "${config.home.homeDirectory}/Documents";

            publicShare = null;
            templates = null;

            music = "${config.home.homeDirectory}/Media/Music";
            pictures = "${config.home.homeDirectory}/Media/Pictures";
            videos = "${config.home.homeDirectory}/Media/Videos";

            extraConfig = {
              SCREENSHOTS = "${config.xdg.userDirs.pictures}/Screenshots";
            };
          };

          mimeApps = {
            enable = true;
            associations.added = associations;
            defaultApplications = associations;
          };
        };
      };
    };
}
