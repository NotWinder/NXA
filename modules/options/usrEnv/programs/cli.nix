{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.modules.usrEnv.programs.cli = {
    enable = mkEnableOption "CLI package sets" // {default = true;};

    adb.enable = mkEnableOption "Android Debug Bridge ";
  };
}
