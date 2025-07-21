{
  inputs',
  pkgs,
  ...
}: {
  xdg.configFile = let
    winpaper = inputs'.winpaper.packages;
  in {
    # Scripts directory (from the packaged scripts)
    "caelestia/shell.json" = {
      text = ''
        {
            "paths": {
                "wallpaperDir": "${winpaper.wallpkgs}/share/wallpapers/"
            }
        }
      '';
    };
  };
  # Main packages
  home.packages = with pkgs; [
    inputs'.caelestia-cli.packages.default
    inputs'.caelestia-shell.packages.default

    nerd-fonts.jetbrains-mono
  ];
}
