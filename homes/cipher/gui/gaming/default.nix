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
  ];

  config = mkIf prg.gaming.enable {
    home.packages = with pkgs; [
      # runtime
      heroic # Native GOG, Epic, and Amazon Games Launcher for Linux, Windows and Mac
      ludusavi # Backup tool for PC game saves
      mono # general dotnet apps
      pcsx2 # Playstation 2 emulator
      protonplus # Simple Wine and Proton-based compatibility tools manager
      winetricks # wine helper utility
    ];
  };
}
