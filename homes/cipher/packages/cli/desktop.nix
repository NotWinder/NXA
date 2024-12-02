{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;

  prg = modules.system.programs;
  dev = modules.device;
  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = mkIf ((builtins.elem dev.type acceptedTypes) && prg.cli.enable) {
    home.packages = with pkgs; [
      # CLI
      libnotify # Library that sends desktop notifications to a notification daemon
      imagemagick # Software suite to create, edit, compose, or convert bitmap images
      bitwarden-cli # Secure and free password manager for all of your devices
      trash-cli # Command line interface to the freedesktop.org trashcan
      slides # Terminal based presentation tool
      brightnessctl # This program allows you read and control device brightness
      pamixer # Pulseaudio command line mixer
      nix-tree # Interactively browse a Nix store paths dependencies
    ];
  };
}
