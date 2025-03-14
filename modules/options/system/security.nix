{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.modules.system.security = {
    fixWebcam = mkEnableOption "the purposefully disabled webcam by un-blacklisting the related kernel module.";
    tor.enable = mkEnableOption "Tor daemon";
  };
}
