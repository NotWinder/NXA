{
  inputs',
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    brightnessctl
    bun
    dart-sass
    fd
    gtk3
    inputs'.hyprpaper.packages.default
    inputs'.hyprpicker.packages.default
    inputs'.matugen.packages.default
    networkmanager
    pavucontrol
    slurp
    swappy
    wayshot
    wf-recorder
    wl-clipboard
  ];

  programs.ags = {
    enable = true;
    configDir = ./config;
    # extraPackages = with pkgs; [
    #   accountsservice
    # ];
  };
}
