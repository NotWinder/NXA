{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.modules.usrEnv.programs.gui = {
    enable = mkEnableOption "GUI package sets" // {default = true;};

    libreoffice.enable = mkEnableOption "LibreOffice suite";
    obs.enable = mkEnableOption "OBS Studio";
    zathura.enable = mkEnableOption "Zathura document viewer";
  };
}
