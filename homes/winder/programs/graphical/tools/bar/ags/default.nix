{
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
    inputs.hyprpaper.packages.${pkgs.stdenv.system}.default
    inputs.hyprpicker.packages.${pkgs.stdenv.system}.default
    inputs.matugen.packages.${pkgs.stdenv.system}.default
    networkmanager
    pavucontrol
    slurp
    swappy
    swww
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
