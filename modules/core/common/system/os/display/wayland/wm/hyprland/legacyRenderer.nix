{ pkgs, inputs, config, ... }: {
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland.override { legacyRenderer = true; };
    xwayland.enable = true;
  };
}
