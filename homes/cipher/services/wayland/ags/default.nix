{
  inputs,
  inputs',
  pkgs,
  ...
}: {
  imports = [inputs.ags.homeManagerModules.default];

  home.packages = with pkgs; [
    inputs'.ags.packages.notifd
    inputs'.ags.packages.mpris
    inputs'.ags.packages.auth
    inputs'.matugen.packages.default
    material-symbols
    wl-screenrec
  ];

  programs.ags = {
    enable = true;
    extraPackages = [
      pkgs.libsoup_3
      pkgs.gtksourceview
      pkgs.libnotify
      pkgs.webkitgtk_4_1
      pkgs.gst_all_1.gstreamer
      inputs'.ags.packages.apps
      inputs'.ags.packages.battery
      inputs'.ags.packages.hyprland
      inputs'.ags.packages.wireplumber
      inputs'.ags.packages.network
      inputs'.ags.packages.tray
      inputs'.ags.packages.battery
      inputs'.ags.packages.notifd
      inputs'.ags.packages.mpris
      inputs'.ags.packages.bluetooth
      inputs'.ags.packages.auth
    ];
  };
}
