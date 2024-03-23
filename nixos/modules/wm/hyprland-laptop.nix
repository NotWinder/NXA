{ pkgs, inputs, config, username, asztal, ... }: {

  programs.hyprland = {
    enable = true;
    inputs.hyprland.packages.${pkgs.system}.hyprland = {
      legacyRenderer = true; # whether to use the legacy renderer (for old GPUs)
    };
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
