{
  config.modules.usrEnv = {
    desktop = "Hyprland";
    desktops."i3".enable = true;
    useHomeManager = true;

    programs = {
      media.mpv.enable = true;
      media.ncmpcpp.enable = true;

      browser = {
        zen.enable = true;
      };

      launchers = {
        anyrun.enable = true;
        tofi.enable = true;
      };

      screenlock.swaylock.enable = true;
    };
    services.media.mpd.enable = true;
  };
}
