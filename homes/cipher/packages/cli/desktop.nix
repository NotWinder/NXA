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
      bitwarden-cli # Secure and free password manager for all of your devices
      brightnessctl # This program allows you read and control device brightness
      imagemagick # Software suite to create, edit, compose, or convert bitmap images
      libnotify # Library that sends desktop notifications to a notification daemon
      nix-tree # Interactively browse a Nix store paths dependencies
      pamixer # Pulseaudio command line mixer
      sing-box # Universal proxy platform
      slides # Terminal based presentation tool
      tldr # Simplified and community-driven man pages
      tokei # Program that allows you to count your code, quickly
      unrar # Utility for RAR archives
      ventoy-full # New Bootable USB Solution
    ];
  };
}
