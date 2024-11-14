{pkgs, ...}: {
  home.packages = [pkgs.dconf];
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    theme = {
      package = pkgs.tokyonight-gtk-theme;
      name = "Tokyonight-Dark-BL-LB";
    };
    cursorTheme = {
      name = "⚪ Skyrim by ru5tyshark ⚪";
      size = 33;
    };
  };
}
