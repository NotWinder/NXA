{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  inherit (builtins) elem;
  inherit (lib) mkIf getExe mkGraphicalService;
  inherit (osConfig) modules;

  prg = modules.usrEnv.programs;
in {
  config = mkIf (elem "swaybg" prg.wallpapers) {
    systemd.user.services = {
      swaybg = mkGraphicalService {
        Unit.Description = "Wallpaper chooser service";
        Service = let
          wall = builtins.fetchurl {
            url = "https://raw.githubusercontent.com/catppuccin/wallpapers/main/wallpapers/catppuccin/01.png";
            sha256 = lib.fakeHash;
          };
        in {
          ExecStart = "${getExe pkgs.swaybg} -i ${wall}";
          Restart = "always";
        };
      };
    };
  };
}
