{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkDefault;
in {
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  i18n = let
    defaultLocale = "en_US.UTF-8";
  in {
    inherit defaultLocale;

    extraLocaleSettings = {
      LANG = defaultLocale;
      LC_COLLATE = defaultLocale;
      LC_CTYPE = defaultLocale;
      LC_MESSAGES = defaultLocale;

      LC_ADDRESS = defaultLocale;
      LC_IDENTIFICATION = defaultLocale;
      LC_MEASUREMENT = defaultLocale;
      LC_MONETARY = defaultLocale;
      LC_NAME = defaultLocale;
      LC_NUMERIC = defaultLocale;
      LC_PAPER = defaultLocale;
      LC_TELEPHONE = defaultLocale;
      LC_TIME = defaultLocale;
    };

    supportedLocales = mkDefault [
      "en_US.UTF-8/UTF-8"
    ];

    # IME configuration
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-gtk
        fcitx5-lua
        kdePackages.fcitx5-qt

        # themes
        fcitx5-material-color
      ];
    };
  };
}
