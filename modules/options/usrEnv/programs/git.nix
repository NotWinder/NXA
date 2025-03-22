{lib, ...}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  options.modules.usrEnv.programs.git = {
    enable = mkEnableOption "git versions control" // {default = true;};

    signingKey = mkOption {
      type = types.str;
      default = "";
      description = "The default gpg key used for signing commits";
    };
  };
}
