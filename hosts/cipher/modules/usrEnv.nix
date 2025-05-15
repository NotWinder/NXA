{
  config.modules.usrEnv = {
    desktop = "Hyprland";
    desktops."i3".enable = true;
    useHomeManager = true;

    programs = {
      cli.enable = true;
      gui = {
        enable = true;
        obs.enable = true;
      };

      git.signingKey = "0xB7747DE9EEAAE164";

      browsers = {
        floorp.enable = true;
        librewolf.enable = true;
      };

      terminals = {
        alacritty.enable = true;
      };

      media = {
        beets.enable = true;
        mpv.enable = true;
        ncmpcpp.enable = true;
      };

      default = {
        terminal = "alacritty";
        browser = "floorp";
      };

      launchers = {
        #anyrun.enable = true;
        rofi.enable = true;
        tofi.enable = true;
      };

      screenlock.swaylock.enable = true;

      wallpapers.swww.enable = true;
    };
    services.media.mpd.enable = true;
  };
}
