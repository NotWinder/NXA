{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.attrsets) mapAttrs;
in {
  fonts = {
    enableDefaultPackages = true;

    fontconfig = {
      enable = true;
      hinting.enable = true;
      antialias = true;
      defaultFonts = let
        # fonts that should be in each font family
        # if applicable
        common = [
          "Iosevka Nerd Font"
          "Symbols Nerd Font"
          "Noto Color Emoji"
        ];
      in
        mapAttrs (_: fonts: fonts ++ common) {
          serif = ["Noto Serif"];
          sansSerif = ["Lexend"];
          emoji = ["Noto Color Emoji"];
          monospace = [
            "Source Code Pro Medium"
            "Source Han Mono"
          ];
        };
    };

    fontDir = {
      enable = true;
      decompressFonts = true;
    };

    # font packages that should be installed
    packages = with pkgs; [
      font-awesome
      nerd-fonts.fira-code
      terminus_font

      # defaults worth keeping
      dejavu_fonts
      freefont_ttf
      gyre-fonts
      liberation_ttf # for PDFs, Roman
      roboto
      unifont

      # programming fonts
      nerd-fonts.iosevka
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
      sarasa-gothic

      # desktop fonts
      b612 # high legibility
      comic-neue
      corefonts # MS fonts
      dejavu_fonts
      inter
      lato
      lexend
      material-design-icons
      material-icons # used in widgets and such
      noto-fonts
      noto-fonts-cjk-sans
      source-sans
      work-sans

      noto-fonts-emoji-blob-bin
      source-han-sans
      nerd-fonts.meslo-lg

      # emojis
      noto-fonts-color-emoji
      openmoji-black
      openmoji-color
      twemoji-color-font
    ];
  };
}
