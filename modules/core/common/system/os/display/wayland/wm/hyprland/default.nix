{ pkgs, ... }: {

  imports = [
    ./vulkanRenderer.nix
    #./legacyRenderer.nix
  ];
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

  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
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
    hyprpaper
  ];
}
