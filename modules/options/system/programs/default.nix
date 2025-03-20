{lib, ...}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  imports = [
    ./gaming.nix
  ];

  options.modules.system.programs = {
    cli = {
      enable = mkEnableOption "CLI package sets" // {default = true;};
      adb.enable = mkEnableOption "Android Debug Bridge ";
    };
    gui.enable = mkEnableOption "GUI package sets" // {default = true;};

    libreoffice.enable = mkEnableOption "LibreOffice suite";
    zathura.enable = mkEnableOption "Zathura document viewer";

    noisetorch.enable = mkEnableOption "NoiseTorch noise suppression plugin";
    obs.enable = mkEnableOption "OBS Studio";

    editors = {
      helix.enable = mkEnableOption "Helix text editor";
      neovim.enable = mkEnableOption "Neovim text editor";
      vscode.enable = mkEnableOption "Visual Studio Code";
    };

    terminals = {
      alacritty.enable = mkEnableOption "Alacritty terminal emulator";
      foot.enable = mkEnableOption "Foot terminal emulator";
      kitty.enable = mkEnableOption "Kitty terminal emulator";
      wezterm.enable = mkEnableOption "WezTerm terminal emulator";
    };

    git = {
      signingKey = mkOption {
        type = types.str;
        default = "";
        description = "The default gpg key used for signing commits";
      };
    };

    browser = {
      brave.enable = mkEnableOption "Privacy-oriented browser for Desktop and Laptop computers";
      chromium.enable = mkEnableOption "Open source web browser from Google";
      floorp.enable = mkEnableOption "Fork of Firefox, focused on keeping the Open, Private and Sustainable Web alive, built in Japan";
      librewolf.enable = mkEnableOption "Fork of Firefox, Focused on Privacy, Security And Freedom";
      zen.enable = mkEnableOption "Privacy-Focused Browser";
    };
  };
}
