{lib, ...}: let
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) str enum listOf;
in {
  imports = [
    ./gaming.nix
    ./media.nix
  ];

  # default program options
  options.modules.usrEnv.programs = {
    bar = mkOption {
      type = listOf (enum ["none" "waybar" "quickshell" "quickshell/caelestia" "quickshell/noctalia" "quickshell/dms"]);
      default = ["none"];
      description = ''
        The List of Bars/Shells to be Installed.
      '';
    };

    browsers = mkOption {
      type = listOf (enum ["none" "brave" "chromium" "floorp" "librewolf" "zen"]);
      default = ["none"];
      description = ''
        The List of Browser to be Installed.
      '';
    };

    cli = {
      enable = mkEnableOption "CLI package sets" // {default = true;};

      adb.enable = mkEnableOption "Android Debug Bridge ";
    };

    editors = mkOption {
      type = listOf (enum ["none" "helix" "neovim"]);
      default = ["none"];
      description = ''
        The List of Text Editors to be Installed.
      '';
    };

    git = {
      enable = mkEnableOption "git versions control" // {default = true;};

      signingKey = mkOption {
        type = str;
        default = "";
        description = "The default gpg key used for signing commits";
      };
    };

    gui = {
      enable = mkEnableOption "GUI package sets" // {default = true;};

      libreoffice.enable = mkEnableOption "LibreOffice suite";
      obs.enable = mkEnableOption "OBS Studio";
      zathura.enable = mkEnableOption "Zathura document viewer";
    };

    launchers = mkOption {
      type = listOf (enum ["none" "anyrun" "rofi" "tofi"]);
      default = ["none"];
      description = ''
        The List of Application Launchers to be Installed.
      '';
    };

    screenlock = mkOption {
      type = enum ["none" "hyprlock" "swaylock"];
      default = "none";
      description = ''
        The Screenlocker to be Installed.
      '';
    };

    terminals = mkOption {
      type = listOf (enum ["none" "alacritty" "foot" "ghostty" "kitty" "wezterm"]);
      default = ["none"];
      description = ''
        The List of Terminal Emulators Launchers to be Installed.
      '';
    };

    wallpapers = mkOption {
      type = listOf (enum ["none" "hyprpaper" "swaybg" "swww"]);
      default = ["none"];
      description = ''
        The List of Wallpaper Setting Applications to be Installed.
      '';
    };

    default = {
      # what program should be used as the default terminal
      terminal = mkOption {
        type = enum ["alacritty" "foot" "kitty" "wezterm"];
        default = "kitty";
      };

      fileManager = mkOption {
        type = enum ["dolphin" "nemo" "thunar"];
        default = "dolphin";
      };

      browser = mkOption {
        type = enum ["brave" "chromium" "floorp" "librewolf" "zen"];
        default = "chromium";
      };

      editor = mkOption {
        type = enum ["emacs" "helix" "neovim"];
        default = "neovim";
      };

      launcher = mkOption {
        type = enum ["anyrun" "rofi" "wofi"];
        default = "rofi";
      };
    };
  };
}
