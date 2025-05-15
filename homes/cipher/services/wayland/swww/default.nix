{
  inputs',
  osConfig,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  inherit (osConfig) modules;
  env = modules.usrEnv;
  swww = inputs'.swww.packages.default;
in {
  imports = [
    ./scripts
  ];

  config = mkIf env.programs.wallpapers.swww.enable {
    services.swww = {
      enable = true;
      package = swww;
    };
  };
}
