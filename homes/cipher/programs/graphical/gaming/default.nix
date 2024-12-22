{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (osConfig) modules;

  env = modules.usrEnv;
  prg = env.programs;
in {
  imports = [
    ./minecraft.nix
    ./mangohud.nix
    ./chess.nix
  ];

  config = mkIf prg.gaming.enable {
    home.packages = with pkgs; [
      # runtime
      bottles # Easy-to-use wineprefix manager
      heroic # Native GOG, Epic, and Amazon Games Launcher for Linux, Windows and Mac
      mono # general dotnet apps
      pcsx2 # Playstation 2 emulator
      winetricks # wine helper utility
    ];
  };
}
