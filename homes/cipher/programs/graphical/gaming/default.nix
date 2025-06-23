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
    ./mangohud.nix
    ./chess.nix
  ];

  config = mkIf prg.gaming.enable {
    home.packages = with pkgs; [
      # runtime
      protonplus
      heroic # Native GOG, Epic, and Amazon Games Launcher for Linux, Windows and Mac
      mono # general dotnet apps
      pcsx2 # Playstation 2 emulator
      winetricks # wine helper utility
      ludusavi # Backup tool for PC game saves

      # custom shell scripts
      #game-mount
      #game-umount
    ];
  };
}
