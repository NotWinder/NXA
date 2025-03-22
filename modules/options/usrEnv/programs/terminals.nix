{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.modules.usrEnv.programs.terminals = {
    alacritty.enable = mkEnableOption "Alacritty terminal emulator";
    foot.enable = mkEnableOption "Foot terminal emulator";
    kitty.enable = mkEnableOption "Kitty terminal emulator";
    wezterm.enable = mkEnableOption "WezTerm terminal emulator";
  };
}
