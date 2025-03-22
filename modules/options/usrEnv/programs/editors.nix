{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.modules.usrEnv.programs.editors = {
    helix.enable = mkEnableOption "Helix text editor";
    neovim.enable = mkEnableOption "Neovim text editor";
    vscode.enable = mkEnableOption "Visual Studio Code";
  };
}
