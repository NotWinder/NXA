{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption literalExpression;
  inherit (lib.types) bool listOf package;
  inherit (config) modules;

  sys = modules.system;
in {
  options.modules.usrEnv.programs.media = {
    addDefaultPackages = mkOption {
      type = bool;
      default = sys.video.enable;
      description = ''
        Whether to enable the default list of media-related packages ranging from audio taggers
        to video editors.
      '';
    };

    extraPackages = mkOption {
      type = listOf package;
      default = [];
      description = ''
        Additional packages that will be appended to media related packages.
      '';
    };

    ncmpcpp.enable = mkEnableOption "ncmpcpp TUI music player";

    beets.enable = mkEnableOption "beets media library system.";

    mpv = {
      enable = mkEnableOption "mpv media player";
      scripts = mkOption {
        type = listOf package;
        description = "A list of MPV scripts that will be enabled";
        example = literalExpression ''[ pkgs.mpvScripts.cutter ]'';
        default = with pkgs.mpvScripts; [
          # from nixpkgs
          cutter # cut and automatically concat videos
          mpris # MPRIS plugin
          thumbnail # OSC seekbar thumbnails
          thumbfast # on-the-fly thumbnailer
          sponsorblock # skip sponsored segments
          uosc # proximity UI
          quality-menu # ytdl-format quality menu
          occivink.seekTo # seek to specific pos.
        ];
      };
    };
  };
}
