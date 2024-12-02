{
  osConfig,
  lib,
  pkgs,
  #inputs',
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;

  prg = modules.system.programs;
in {
  config = mkIf prg.cli.enable {
    home.packages = with pkgs; [
      # packages from inputs
      #inputs'.agenix.packages.default
      #inputs'.nyxexprs.packages.cloneit

      # CLI packages from nixpkgs
      catimg # Insanely fast image printing in your terminal
      duf # Disk Usage/Free Utility
      todo # Simple todo cli program written in rust
      hyperfine # Command-line benchmarking tool
      fzf # Command-line fuzzy finder written in Go
      file # Program that shows the type of files
      unzip # Extraction utility for archives compressed in .zip format
      ripgrep # Utility that combines the usability of The Silver Searcher with the raw speed of grep
      rsync # Fast incremental file transfer utility
      fd # Simple, fast and user-friendly alternative to find
      jq # Lightweight and flexible command-line JSON processor
      figlet # Program for making large letters out of ordinary text
      lm_sensors # Tools for reading hardware sensors
      dconf # TODO: check what it does
      nitch # Incredibly fast system fetch written in nim
      skim # Command-line fuzzy finder written in Rust
      p7zip # New p7zip fork with additional codecs and improvements
      btop # Monitor of resources
    ];
  };
}
