{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  env = config.modules.usrEnv;
in {
  imports = [./config.nix];
  config.hm = mkIf (env.desktop == "sway") {
    wayland.windowManager.sway = {
      enable = true;
      package = pkgs.swayfx;
    };
  };
}
