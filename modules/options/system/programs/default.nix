{lib, ...}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  imports = [
    ./gaming.nix
  ];

  options.modules.system.programs = {
    gui.enable = mkEnableOption "GUI package sets" // {default = true;};
    cli.enable = mkEnableOption "CLI package sets" // {default = true;};
    dev.enable = mkEnableOption "development related package sets";

    libreoffice.enable = mkEnableOption "LibreOffice suite";
    noisetorch.enable = mkEnableOption "NoiseTorch noise suppression plugin";
    obs.enable = mkEnableOption "OBS Studio";
    steam.enable = mkEnableOption "Steam game client";
    vscode.enable = mkEnableOption "Visual Studio Code";
    zathura.enable = mkEnableOption "Zathura document viewer";

    editors = {
      neovim.enable = mkEnableOption "Neovim text editor";
      helix.enable = mkEnableOption "Helix text editor";
    };

    terminals = {
      alacritty.enable = mkEnableOption "Alacritty terminal emulator";
      foot.enable = mkEnableOption "Foot terminal emulator";
      ghostty.enable = mkEnableOption "Ghostty terminal emulator";
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

    # default program options
    default = {
      # what program should be used as the default terminal
      terminal = mkOption {
        type = types.enum ["alacritty" "foot" "ghostty" "kitty" "wezterm"];
        default = "kitty";
      };

      fileManager = mkOption {
        type = types.enum ["thunar" "dolphin" "nemo"];
        default = "dolphin";
      };

      browser = mkOption {
        type = types.enum ["zen" "librewolf" "chromium"];
        default = "zen";
      };

      editor = mkOption {
        type = types.enum ["neovim" "helix" "emacs"];
        default = "neovim";
      };

      launcher = mkOption {
        type = types.enum ["rofi" "wofi" "anyrun"];
        default = "rofi";
      };
    };
  };
}
