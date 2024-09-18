{
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      autoNumlock = true;
      settings = {
        Autologin = {
          Session = "hyprland";
          User = "winder";
        };
      };
    };
  };
}
