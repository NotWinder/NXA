{ config
, pkgs
, lib
, ...
}:
let
  inherit (pkgs) plymouth;
  inherit (lib) mkIf;

  cfg = config.custom.system.boot.plymouth;
in
{
  config = mkIf cfg.enable {
    # configure plymouth theme
    # <https://github.com/adi1090x/plymouth-themes>
    boot.plymouth =
      {
        enable = true;
      }
      // lib.optionalAttrs cfg.withThemes {
        themePackages = [ (pkgs.adi1090x-plymouth-themes.override { selected_themes = [ cfg.theme ]; }) ];

        inherit (cfg) theme;
      };

    # make plymouth work with sleep
    powerManagement = {
      powerDownCommands = ''
        ${plymouth}/bin/plymouth --show-splash
      '';
      resumeCommands = ''
        ${plymouth}/bin/plymouth --quit
      '';
    };
  };
}
