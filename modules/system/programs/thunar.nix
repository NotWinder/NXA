{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config) modules;

  prg = modules.usrEnv.programs;
in {
  config = mkIf prg.gui.enable {
    programs.thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-media-tags-plugin
      ];
    };

    environment = {
      systemPackages = with pkgs; [
        ffmpegthumbnailer
        libgsf
        tumbler
      ];
    };

    services.tumbler.enable = true;
  };
}
