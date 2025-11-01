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

      bar = ["quickshell/dms"];

      browsers = ["librewolf"];

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
