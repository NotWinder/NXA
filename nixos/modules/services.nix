{
  services = {
    ## Enable Xserver
    xserver = {
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
    ## Enable GVFS
    gvfs.enable = true;
    ## Enable the OpenSSH daemon.
    openssh.enable = true;
    ## Enable Pipewire
    pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    ## Jellyfin
    jellyfin.enable = true;
    ## Sing-box
    sing-box.enable = true;
    ## Resolved
    resolved.enable = true;
    ## Flatpak
   #flatpak.enable = true;
  };
}
