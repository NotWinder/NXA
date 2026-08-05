{ config
, lib
, ...
}:
let
  inherit (lib) mkIf mkDefault;
in
{
  imports = [
    ./firejail.nix
    ./tor.nix
  ];

  config = {
    # Former workstation role (PLAN 2.2): tag + system security now ride on the
    # profile's enable flag, so the roles class only keeps graphical/headless/server.
    system.nixos.tags = mkIf config.custom.profiles.workstation.enable [ "workstation" ];

    custom.usrEnv = mkIf config.custom.profiles.workstation.enable {
      programs = {
        browsers = mkDefault [ "librewolf" ];
        terminals = mkDefault [ "alacritty" "ghostty" ];
        launchers = mkDefault [ "rofi" "tofi" ];

        default = {
          terminal = mkDefault "alacritty";
          browser = mkDefault "librewolf";
        };

        gui = {
          libreoffice.enable = true;
          obs.enable = mkDefault true;
          zathura.enable = true;
        };

        media = {
          beets.enable = mkDefault true;
          mpv.enable = mkDefault true;
          ncmpcpp.enable = mkDefault true;
        };
      };

      services.media.mpd.enable = mkDefault true;
    };
  };
}
