{
  inputs',
  pkgs,
  lib,
  ...
}: let
  inherit (lib.options) mkEnableOption mkOption literalExpression;
  inherit (lib.types) listOf bool package;
in {
  options.modules.system.programs.media = {
    addDefaultPackages = mkOption {
      type = bool;
      default = true;
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

    mpv = {
      enable = mkEnableOption "mpv media player";
      scripts = mkOption {
        type = listOf package;
        description = "A list of MPV scripts that will be enabled";
        example = literalExpression ''[ pkgs.mpvScripts.cutter ]'';
        default = with pkgs.mpvScripts; [
          cutter
          mpris # MPRIS plugin
          thumbnail # OSC seekbar thumbnails
          thumbfast # on-the-fly thumbnailer
          sponsorblock # skip sponsored segments
          uosc # proximity UI
          quality-menu # ytdl-format quality menu
          seekTo # seek to spefici pos.
          inputs'.nyxpkgs.packages.mpv-history # save a history of played files with timestamps
        ];
      };
    };
  };
}
