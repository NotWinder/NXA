{
  inputs,
  inputs',
  pkgs,
  ...
}: {
  # add the home manager module
  imports = [inputs.ags.homeManagerModules.default];

  programs.ags = {
    enable = true;

    # symlink to ~/.config/ags
    #configDir = ../ags;

    # additional packages to add to gjs's runtime
    extraPackages = with pkgs; [
      inputs'.ags.packages.battery
      inputs'.ags.packages.hyprland
      inputs'.ags.packages.mpris
      inputs'.ags.packages.network
      inputs'.ags.packages.notifd
      inputs'.ags.packages.tray
      inputs'.ags.packages.wireplumber
      fzf
    ];
  };
}
