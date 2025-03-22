{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
in {
  config.modules.usrEnv.programs.gui = mkIf config.modules.profiles.workstation.enable {
    libreoffice.enable = true;
    zathura.enable = true;
  };
}
