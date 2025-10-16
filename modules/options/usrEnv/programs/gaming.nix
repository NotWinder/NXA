{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkEnableOption;
  inherit (config) modules;

  env = modules.usrEnv;
  prg = env.programs;
in {
  options.modules.usrEnv.programs.gaming = {
    enable = mkEnableOption ''
      packages, services and warappers required for the device to be gaming-ready.

      Setting this option to true will also enable certain other options with
      the option to disable them explicitly.
    '';

    chess.enable = mkEnableOption "Chess programs and engines";
    emulation.enable = mkEnableOption "programs required to emulate other platforms" // {default = prg.gaming.enable;};
    gamemode.enable = mkEnableOption "Feral-Interactive's Gamemode with userspace optimizations" // {default = prg.gaming.enable;};
    gamescope.enable = mkEnableOption "Gamescope compositing manager" // {default = prg.gaming.enable;};
    mangohud.enable = mkEnableOption "MangoHud overlay" // {default = prg.gaming.enable;};
    steam.enable = mkEnableOption "Steam client" // {default = prg.gaming.enable;};
    wine.enable = mkEnableOption "wine compatibality layer to run windows apps on linux" // {default = prg.gaming.enable;};
  };
}
