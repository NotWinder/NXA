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

      browsers = ["floorp" "librewolf"];

      terminals = ["alacritty" "ghostty"];

      media = {
        beets.enable = true;
        mpv.enable = true;
        ncmpcpp.enable = true;
      };

      default = {
        terminal = "alacritty";
        browser = "librewolf";
      };

      launchers = ["rofi" "tofi"];
    };
    services.media.mpd.enable = true;
  };
}
