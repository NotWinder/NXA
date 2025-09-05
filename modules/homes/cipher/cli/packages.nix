{
  config,
  lib,
  pkgs,
  #inputs',
  ...
}: let
  inherit (lib) mkIf;
  inherit (config) modules;

  prg = modules.usrEnv.programs;
in {
  config.hm = mkIf prg.cli.enable {
    home.packages = with pkgs; [
      duf # Disk Usage/Free Utility
      todo # Simple todo cli program written in rust
      hyperfine # Command-line benchmarking tool
      fzf # Command-line fuzzy finder written in Go
      rsync # Fast incremental file transfer utility
      fd # Simple, fast and user-friendly alternative to find
      jq # Lightweight and flexible command-line JSON processor
      figlet # Program for making large letters out of ordinary text
      nitch # Incredibly fast system fetch written in nim
      skim # Command-line fuzzy finder written in Rust

      imagemagick # Software suite to create, edit, compose, or convert bitmap images
      libnotify # Library that sends desktop notifications to a notification daemon
      slides # Terminal based presentation tool
      tldr # Simplified and community-driven man pages
      tokei # Program that allows you to count your code, quickly
      unionfs-fuse # FUSE UnionFS implementation
      ventoy-full # New Bootable USB Solution

      # CLI
      wl-clipboard # Command-line copy/paste utilities for Wayland
    ];
  };
}
