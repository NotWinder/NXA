{
  config,
  pkgs,
  ...
}: let
  cfg = config.modules.style.qt;
in {
  config.modules.style = {
    forceGtk = true;
    useKvantum = true;

    qt = {
      enable = true;
      theme = {
        name = "Catppuccin-Mocha-Dark";
        package = pkgs.catppuccin-kde.override {
          flavour = ["mocha"];
          accents = ["green"];
          winDecStyles = ["modern"];
        };
      };
      #kvantum = {
      #  package = pkgs.catppuccin-kvantum.override {
      #    accent = "green";
      #    variant = "mocha";
      #  };
      #  kvconfig = "${cfg.kvantum.package}/share/Kvantum/Catppuccin-Mocha-Green/Catppuccin-Mocha-Green.kvconfig";
      #  svg = "${cfg.kvantum.package}/share/Kvantum/Catppuccin-Mocha-Green/Catppuccin-Mocha-Green.svg";
      #};
      #kdeglobals = {
      #  package = "${cfg.theme.package}/share/color-schemes/CatppuccinMochaGreen.colors";
      #  colors = "${cfg.theme.package}/share/color-schemes/CatppuccinMochaGreen.colors";
      #  #TerminalApplication = "alacritty";
      #};
    };

    gtk = {
      enable = true;
      usePortal = true;
      theme = {
        name = "Tokyonight-Dark";
        package = pkgs.tokyonight-gtk-theme;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
    };
  };
}
