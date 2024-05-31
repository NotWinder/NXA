{
  ## Enable Xserver
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      settings = {
        Autologin = {
          Session = "hyprland";
          User = "winder";
        };
      };
    };
  };
}
