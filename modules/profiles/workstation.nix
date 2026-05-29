{ config
, lib
, ...
}:
let
  inherit (lib) mkIf;
in
{
  config.custom.usrEnv.programs.gui = mkIf config.custom.profiles.workstation.enable {
    libreoffice.enable = true;
    zathura.enable = true;
  };
}
