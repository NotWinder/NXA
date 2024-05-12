{pkgs, ...}:

{

    gtk={
        enable = true;
        iconTheme = {
            package = pkgs.papirus-icon-theme;
            name = "Papirus-Dark";
        };
        theme = {
            package = pkgs.tokyonight-gtk-theme;
            name = "Tokyonight-Storm-BL";
        };
    };
}
