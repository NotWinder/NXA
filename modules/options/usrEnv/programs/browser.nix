{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkEnableOption;
  inherit (config) modules;

  sys = modules.system;
  prg = sys.programs;
  def = prg.default;

  isChromium = def.browser == "chromium";
  isLibrewolf = def.browser == "librewolf";
  isZen = def.browser == "zen";
in {
  options.modules.usrEnv.programs.browser = {
    chromium.enable = mkEnableOption "Open source web browser from Google" // {default = isChromium;};
    librewolf.enable = mkEnableOption "Fork of Firefox, Focused on Privacy, Security And Freedom" // {default = isLibrewolf;};
    zen.enable = mkEnableOption "Privacy-Focused Browser" // {default = isZen;};
  };
}
