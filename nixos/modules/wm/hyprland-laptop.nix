{ pkgs, inputs, config, username, asztal, ... }: {


  inputs.hyprland.packages.${pkgs.system}.hyprland.override = {
    legacyRenderer = true;
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  security = {
    polkit.enable = true;
    pam.services.ags = { };
  };

  environment.systemPackages = with pkgs; with gnome; [
    gnome.adwaita-icon-theme
    loupe
    adwaita-icon-theme
    gnome-calendar
    gnome-boxes
    gnome-system-monitor
    gnome-control-center
    wl-gammactl
    wl-clipboard
    wayshot
    rofi
    pavucontrol
    brightnessctl
    swww
  ];

}
