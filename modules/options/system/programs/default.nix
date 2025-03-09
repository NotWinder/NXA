{lib, ...}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  imports = [
    ./gaming.nix
  ];

  options.modules.system.programs = {
    cli.enable = mkEnableOption "CLI package sets" // {default = true;};
    gui.enable = mkEnableOption "GUI package sets" // {default = true;};

    libreoffice.enable = mkEnableOption "LibreOffice suite";
    noisetorch.enable = mkEnableOption "NoiseTorch noise suppression plugin";
    obs.enable = mkEnableOption "OBS Studio";
    steam.enable = mkEnableOption "Steam game client";
    vscode.enable = mkEnableOption "Visual Studio Code";
    zathura.enable = mkEnableOption "Zathura document viewer";

    editors = {
      helix.enable = mkEnableOption "Helix text editor";
      neovim.enable = mkEnableOption "Neovim text editor";
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

    # default program options
    default = {
      # what program should be used as the default terminal
      terminal = mkOption {
        type = types.enum ["alacritty" "foot" "kitty" "wezterm"];
        default = "kitty";
      };

      fileManager = mkOption {
        type = types.enum ["dolphin" "nemo" "thunar"];
        default = "dolphin";
      };

      browser = mkOption {
        type = types.enum ["brave" "chromium" "librewolf" "zen"];
        default = "chromium";
      };

      editor = mkOption {
        type = types.enum ["emacs" "helix" "neovim"];
        default = "neovim";
      };

      launcher = mkOption {
        type = types.enum ["anyrun" "rofi" "wofi"];
        default = "rofi";
      };
    };
  };
}
