{
  config.modules.usrEnv = {
    desktop = "Hyprland";
    useHomeManager = true;

    programs = {
      cli.enable = true;
      gui = {
        enable = true;
        obs.enable = true;
      };

      git.signingKey = "0xB7747DE9EEAAE164";

      bar = ["quickshell/caelestia" "quickshell"];

      browsers = ["floorp" "librewolf"];

      terminals = ["alacritty" "ghostty"];

      wallpapers = ["swww"];

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
