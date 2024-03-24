{
  ## Enable Xserver
  services.xserver.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      settings = {
       #Autologin = {
       #  Session = "hyprland";
       #  User = "winder";
       #};
      };
    };
  };
}
