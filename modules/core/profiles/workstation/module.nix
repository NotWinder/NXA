{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
in {
  config.modules.system.programs = mkIf config.modules.profiles.workstation.enable {
    libreoffice.enable = true;
    zathura.enable = true;
  };
}
