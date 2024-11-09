{pkgs, ...}: {
  imports = [
    ./vulkanRenderer.nix
    #./legacyRenderer.nix
  ];

  environment.systemPackages = with pkgs; [
    gnome-calendar
    loupe
    pavucontrol
    wayshot
    wl-clipboard
    wl-gammactl
  ];
}
