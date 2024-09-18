{ pkgs, ... }: {

  imports = [
    ./vulkanRenderer.nix
    #./legacyRenderer.nix
  ];
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
    ];
  };

  environment.systemPackages = with pkgs; [
    gnome-calendar
    loupe
    pavucontrol
    wayshot
    wl-clipboard
    wl-gammactl
  ];
}
