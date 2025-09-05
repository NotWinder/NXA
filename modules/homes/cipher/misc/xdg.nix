{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config) modules;

  def = modules.usrEnv.programs.default;

  browser = ["${def.browser}.desktop"];
  zathura = ["zathura.desktop"];
  fileManager = ["org.kde.dolphin.desktop"];

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
    "application/x-xz-compressed-tar" = ["org.kde.ark.desktop"];

    "audio/*" = ["mpv.desktop"];
    "video/*" = ["mpv.desktop"];
    "image/*" = ["imv.desktop"];
    "application/json" = browser;
    "application/pdf" = zathura;

    "x-scheme-handler/tg" = ["telegramdesktop.desktop"];
  };

  template = import lib.xdgTemplate "home-manager";
in {
  config.hm = {
    xdg = {
      enable = true;
      cacheHome = "${config.hm.home.homeDirectory}/.cache";
      configHome = "${config.hm.home.homeDirectory}/.config";
      dataHome = "${config.hm.home.homeDirectory}/.local/share";
      stateHome = "${config.hm.home.homeDirectory}/.local/state";

      configFile = {
        "npm/npmrc" = template.npmrc;
        "python/pythonrc" = template.pythonrc;
      };

      userDirs = {
        enable = pkgs.stdenv.isLinux;
        createDirectories = true;

        download = "${config.hm.home.homeDirectory}/Downloads";
        desktop = "${config.hm.home.homeDirectory}/Desktop";
        documents = "${config.hm.home.homeDirectory}/Documents";

        publicShare = null;
        templates = null;

        music = "${config.hm.home.homeDirectory}/Media/Music";
        pictures = "${config.hm.home.homeDirectory}/Media/Pictures";
        videos = "${config.hm.home.homeDirectory}/Media/Videos";

        extraConfig = {
          XDG_SCREENSHOTS_DIR = "${config.hm.xdg.userDirs.pictures}/Screenshots";
        };
      };

      mimeApps = {
        enable = true;
        associations.added = associations;
        defaultApplications = associations;
      };
    };
  };
}
