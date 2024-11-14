{pkgs, ...}: {
  config.modules.style = {
    forceGtk = true;
    useKvantum = true;

    qt.enable = true;
    gtk = {
      enable = true;
      usePortal = true;
      theme = {
        package = pkgs.tokyonight-gtk-theme;
        name = "Tokyonight-Dark-BL-LB";
      };
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus-Dark";
      };
    };
  };
}
