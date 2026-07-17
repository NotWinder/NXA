{ config, pkgs, ... }: {
  config.custom.style = {
    forceGtk = true;

    qt.enable = true;

    gtk = {
      enable = true;
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
    };
  };
}
