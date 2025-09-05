{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config) modules;

  prg = modules.usrEnv.programs;
in {
  config.hm = mkIf prg.gui.libreoffice.enable {
    home.packages = with pkgs; [
      libreoffice-qt # Comprehensive, professional-quality productivity suite, a variant of openoffice.org
      hyphen # Text hyphenation library
      hunspell # Spell checker
      hunspellDicts.en_US-large # Hunspell dictionary for English (United States) Large from Wordlist
      hunspellDicts.en_GB-large # Hunspell dictionary for English (United Kingdom) Large from Wordlist
    ];
  };
}
