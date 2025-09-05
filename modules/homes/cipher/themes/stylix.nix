{pkgs, ...}: {
  config = {
    stylix.enable = true;
    stylix.polarity = "dark";
    stylix.base16Scheme = {
      base00 = "17130b";
      base01 = "1f1b13";
      base02 = "2e2921";
      base03 = "999080";
      base04 = "d0c5b4";
      base05 = "ebe1d4";
      base06 = "fdefe0";
      base07 = "ffffff";
      base08 = "ffb4ab";
      base09 = "f2c77f";
      base0A = "e7c26c";
      base0B = "afcfab";
      base0C = "75cf9d";
      base0D = "d7c5a0";
      base0E = "ffad7f";
      base0F = "60594c";
    };
    hm = {
      stylix = {
        enable = true;
        base16Scheme = {
          base00 = "17130b";
          base01 = "1f1b13";
          base02 = "2e2921";
          base03 = "999080";
          base04 = "d0c5b4";
          base05 = "ebe1d4";
          base06 = "fdefe0";
          base07 = "ffffff";
          base08 = "ffb4ab";
          base09 = "f2c77f";
          base0A = "e7c26c";
          base0B = "afcfab";
          base0C = "75cf9d";
          base0D = "d7c5a0";
          base0E = "ffad7f";
          base0F = "60594c";
        };
        polarity = "dark";
        targets.librewolf.enable = false;
        targets.floorp.enable = false;
        cursor = {
          name = "Breeze_Hacked";
          package = pkgs.breeze-hacked-cursor-theme;
          size = 32;
        };
        iconTheme = {
          enable = true;
          dark = "Papirus-Dark";
          light = "Papirus-Light";
          package = pkgs.catppuccin-papirus-folders;
        };
        opacity = {
          terminal = 0.8;
        };
        fonts = {
          emoji = {
            name = "Noto Color Emoji";
            package = pkgs.noto-fonts-color-emoji;
          };
          monospace = {
            name = "Source Code Pro Medium";
            package = pkgs.source-sans;
          };
          sansSerif = {
            name = "Lexend";
            package = pkgs.lexend;
          };
          serif = {
            name = "Noto Serif";
            package = pkgs.noto-fonts;
          };
          sizes = {
            applications = 15;
            desktop = 15;
          };
          #packages = with pkgs; [
          #  font-awesome
          #  nerd-fonts.fira-code
          #  terminus_font

          #  # defaults worth keeping
          #  dejavu_fonts
          #  freefont_ttf
          #  gyre-fonts
          #  liberation_ttf # for PDFs, Roman
          #  roboto
          #  unifont

          #  # programming fonts
          #  nerd-fonts.iosevka
          #  nerd-fonts.jetbrains-mono
          #  nerd-fonts.symbols-only
          #  sarasa-gothic

          #  # desktop fonts
          #  b612 # high legibility
          #  comic-neue
          #  corefonts # MS fonts
          #  dejavu_fonts
          #  inter
          #  lato
          #  material-design-icons
          #  material-icons # used in widgets and such
          #  noto-fonts-cjk-sans
          #  work-sans

          #  noto-fonts-emoji-blob-bin
          #  source-han-sans
          #  nerd-fonts.meslo-lg

          #  # emojis
          #  openmoji-black
          #  openmoji-color
          #  twemoji-color-font
          #];
        };
      };
    };
  };
}
