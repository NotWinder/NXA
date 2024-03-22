{
  services.xserver = {
    ## Enable Xserver
    enable = true;
    ## Configure keymap in X11
    xkb = {
      layout = "us,ir";
      options = "grp:alt_shift_toggle";
    };
  };
}
