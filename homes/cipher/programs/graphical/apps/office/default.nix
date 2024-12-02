{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;

  sys = modules.system;
  prg = sys.programs;
in {
  config = mkIf prg.libreoffice.enable {
    home.packages = with pkgs; [
      libreoffice-qt # Comprehensive, professional-quality productivity suite, a variant of openoffice.org
      hyphen # Text hyphenation library
      hunspell # Spell checker
      hunspellDicts.en_US-large # Hunspell dictionary for English (United States) Large from Wordlist
      hunspellDicts.en_GB-large # Hunspell dictionary for English (United Kingdom) Large from Wordlist
    ];
  };
}
