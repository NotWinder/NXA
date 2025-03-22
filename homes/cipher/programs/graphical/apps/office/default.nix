{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;

  prg = modules.usrEnv.programs;
  gui = prg.gui;
in {
  config = mkIf gui.libreoffice.enable {
    home.packages = with pkgs; [
      libreoffice-qt # Comprehensive, professional-quality productivity suite, a variant of openoffice.org
      hyphen # Text hyphenation library
      hunspell # Spell checker
      hunspellDicts.en_US-large # Hunspell dictionary for English (United States) Large from Wordlist
      hunspellDicts.en_GB-large # Hunspell dictionary for English (United Kingdom) Large from Wordlist
    ];
  };
}
