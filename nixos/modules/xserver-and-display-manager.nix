{
  ## Enable Xserver
  services.xserver = {
    enable = true;
    displayManager = {
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
    ## Configure keymap in X11
    xkb = {
      layout = "us,ir";
      options = "grp:alt_shift_toggle";
    };
    ## Enable Nvidia
    videoDrivers = [ "nvidia" ];
  };
}
