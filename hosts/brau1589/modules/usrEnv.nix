{
  config = {
    custom = {
      programs = {
        hyprland.enable = true;
        niri.enable = true;
        dms.enable = true;
      };
      services.greetd = {
        enable = true;
        autoLogin = {
          enable = true;
          command = "niri-session";
        };
      };
    };
    modules.usrEnv = {
      useHomeManager = true;

      programs = {
        cli.enable = true;
        gui = {
          enable = true;
          obs.enable = true;
        };

        browsers = ["librewolf" "zen-beta"];

        terminals = ["alacritty" "ghostty"];

        media = {
          beets.enable = true;
          mpv.enable = true;
          ncmpcpp.enable = true;
        };

        default = {
          terminal = "alacritty";
          browser = "zen-beta";
        };

        launchers = ["rofi" "tofi"];
      };
      services.media.mpd.enable = true;
    };
  };
}
