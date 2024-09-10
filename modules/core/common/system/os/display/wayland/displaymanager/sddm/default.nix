{
    services.xserver.displayManager.setupCommands = ''
        xrandr --output HDMI-A-1 --mode 1440x900 --rate 59.75
        '';
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
