{ config
, pkgs
, lib
, ...
}:
let
  inherit (lib.modules) mkIf;

  prg = config.custom.usrEnv.programs;
in
{
  config = mkIf prg.gaming.steam.enable {
    programs.steam = {
      # Enable steam
      enable = true;

      # Whether to open ports in the firewall for Steam Remote Play
      remotePlay.openFirewall = true;

      # Whether to open ports in the firewall for Source Dedicated Server
      dedicatedServer.openFirewall = true;

      package = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            libkrb5
            keyutils
          ];
      };
    };

    # Valve controller/Steam Deck udev rules come from hardware.steam-hardware,
    # which programs.steam enables; they grant access to the logged-in user
    # (uaccess) instead of the world-writable MODE="0666" rules used before.
    # Extra controllers (DualShock/DualSense, 8BitDo, ...) are covered here.
    services.udev.packages = [ pkgs.game-devices-udev-rules ];
  };
}
