{lib, ...}: let
  inherit (lib) mkOption types;
in {
  imports = [
    ./gaming.nix
    ./launchers.nix
    ./lockers.nix
    ./media.nix
  ];

  # default program options
  options.modules.usrEnv.programs.defaults = {
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
      type = types.enum ["brave" "chromium" "floorp" "librewolf" "zen"];
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
}
