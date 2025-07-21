{
  osConfig,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;

  prg = modules.usrEnv.programs;
in {
  config = mkIf prg.terminals.alacritty.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        general.import = [
          "~/.config/alacritty/themes/themes/marine_dark.toml"
        ];
        window = {
          padding = {
            x = 20;
            y = 0;
          };
        };
      };
    };
  };
}
