{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.modules.usrEnv.programs.browsers = {
    brave.enable = mkEnableOption "Privacy-oriented browser for Desktop and Laptop computers";
    chromium.enable = mkEnableOption "Open source web browser from Google";
    floorp.enable = mkEnableOption "Fork of Firefox, focused on keeping the Open, Private and Sustainable Web alive, built in Japan";
    librewolf.enable = mkEnableOption "Fork of Firefox, Focused on Privacy, Security And Freedom";
    zen.enable = mkEnableOption "Privacy-Focused Browser";
  };
}
